from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.contrib.auth import login, authenticate, logout
from django.contrib.auth.forms import UserCreationForm, AuthenticationForm
from django.contrib import messages
from django.utils import timezone
from django.db.models import Sum, Count
from datetime import datetime, timedelta
from .models import StudentProfile, MealItem, SkippedMeal


# Meal time definitions (24-hour format)
MEAL_TIMES = {
    'Breakfast': datetime.strptime('08:00', '%H:%M').time(),
    'Lunch': datetime.strptime('13:00', '%H:%M').time(),
    'Dinner': datetime.strptime('20:00', '%H:%M').time(),
}


def get_current_and_next_meals():
    """Get current and next available meals based on current system time."""
    today = timezone.now().date()
    current_time = timezone.now().time()
    
    meals = []
    
    # Get today's meals
    todays_meals = MealItem.objects.filter(date=today, is_active=True).order_by('meal_type')
    
    for meal in todays_meals:
        meal_time = MEAL_TIMES.get(meal.meal_type)
        if meal_time:
            meals.append(meal)
    
    # If no more meals today, get tomorrow's meals
    tomorrow = today + timedelta(days=1)
    tomorrows_meals = MealItem.objects.filter(date=tomorrow, is_active=True).order_by('meal_type')
    
    for meal in tomorrows_meals:
        meals.append(meal)
    
    return meals[:3]  # Return up to 3 meals


def can_skip_meal(meal):
    """Check if a meal can still be skipped (at least 2 hours before meal time)."""
    today = timezone.now().date()
    current_time = timezone.now()
    
    meal_time = MEAL_TIMES.get(meal.meal_type)
    if not meal_time:
        return False
    
    # Create datetime for the meal
    meal_datetime = datetime.combine(meal.date, meal_time)
    meal_datetime = timezone.make_aware(meal_datetime)
    
    # Calculate the deadline (2 hours before meal)
    deadline = meal_datetime - timedelta(hours=2)
    
    return current_time < deadline


def register_view(request):
    """User registration view."""
    if request.user.is_authenticated:
        return redirect('dashboard')
    
    if request.method == 'POST':
        form = UserCreationForm(request.POST)
        if form.is_valid():
            user = form.save()
            # Create student profile
            roll_number = request.POST.get('roll_number', '')
            room_number = request.POST.get('room_number', '')
            StudentProfile.objects.create(
                user=user,
                roll_number=roll_number,
                room_number=room_number
            )
            login(request, user)
            messages.success(request, 'Registration successful!')
            return redirect('dashboard')
    else:
        form = UserCreationForm()
    
    return render(request, 'core/register.html', {'form': form})


def login_view(request):
    """User login view."""
    if request.user.is_authenticated:
        return redirect('dashboard')
    
    if request.method == 'POST':
        form = AuthenticationForm(request, data=request.POST)
        if form.is_valid():
            username = form.cleaned_data.get('username')
            password = form.cleaned_data.get('password')
            user = authenticate(username=username, password=password)
            if user is not None:
                login(request, user)
                messages.success(request, f'Welcome back, {username}!')
                return redirect('dashboard')
    else:
        form = AuthenticationForm()
    
    return render(request, 'core/login.html', {'form': form})


def logout_view(request):
    """User logout view."""
    logout(request)
    messages.info(request, 'You have been logged out.')
    return redirect('login')


@login_required
def dashboard_view(request):
    """Student dashboard showing current and upcoming meals."""
    meals = get_current_and_next_meals()
    
    meal_data = []
    for meal in meals:
        has_skipped = SkippedMeal.objects.filter(user=request.user, meal_item=meal).exists()
        can_skip = can_skip_meal(meal)
        meal_time = MEAL_TIMES.get(meal.meal_type)
        
        meal_data.append({
            'meal': meal,
            'has_skipped': has_skipped,
            'can_skip': can_skip and not has_skipped,
            'meal_time': meal_time,
        })
    
    context = {
        'meal_data': meal_data,
    }
    return render(request, 'core/dashboard.html', context)


@login_required
def skip_meal_view(request, meal_id):
    """Handle meal skipping action."""
    meal = get_object_or_404(MealItem, id=meal_id)
    
    # Check if already skipped
    if SkippedMeal.objects.filter(user=request.user, meal_item=meal).exists():
        messages.warning(request, 'You have already skipped this meal.')
        return redirect('dashboard')
    
    # Check if can still skip
    if not can_skip_meal(meal):
        messages.error(request, 'Cannot skip this meal. The deadline has passed.')
        return redirect('dashboard')
    
    # Create skip record
    SkippedMeal.objects.create(user=request.user, meal_item=meal)
    messages.success(request, f'You have opted out of {meal.meal_type} on {meal.date}.')
    
    return redirect('dashboard')


@login_required
def menu_history_view(request):
    """Show menu history and user's skipped meals."""
    skipped_meals = SkippedMeal.objects.filter(user=request.user).order_by('-meal_item__date')
    total_saved = skipped_meals.aggregate(total=Sum('meal_item__cost'))['total'] or 0
    
    context = {
        'skipped_meals': skipped_meals,
        'total_saved': total_saved,
    }
    return render(request, 'core/menu_history.html', context)


@login_required
def manager_stats_view(request):
    """Manager dashboard showing meal statistics - staff access only."""
    # Check if user is staff (manager/warden/chef)
    if not request.user.is_staff:
        messages.error(request, 'Access denied. This area is for managers only.')
        return redirect('dashboard')
    
    today = timezone.now().date()
    
    # Get today's meals
    todays_meals = MealItem.objects.filter(date=today, is_active=True)
    
    total_students = StudentProfile.objects.count()
    
    meal_stats = []
    for meal in todays_meals:
        skipped_count = SkippedMeal.objects.filter(meal_item=meal).count()
        to_cook = total_students - skipped_count
        
        meal_stats.append({
            'meal': meal,
            'skipped_count': skipped_count,
            'to_cook': to_cook,
        })
    
    # Calculate total money saved
    total_money_saved = SkippedMeal.objects.aggregate(
        total=Sum('meal_item__cost')
    )['total'] or 0
    
    context = {
        'total_students': total_students,
        'meal_stats': meal_stats,
        'total_money_saved': total_money_saved,
        'today': today,
    }
    return render(request, 'core/stats.html', context)
