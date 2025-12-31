from django.contrib import admin
from django.utils.safestring import mark_safe
from django.urls import path
from django.shortcuts import render, redirect
from django.contrib import messages
from datetime import date, timedelta
from .models import StudentProfile, MealItem, SkippedMeal, WeeklyMenuTemplate


@admin.register(StudentProfile)
class StudentProfileAdmin(admin.ModelAdmin):
    list_display = ('user', 'roll_number', 'room_number')
    search_fields = ('user__username', 'roll_number', 'room_number')
    list_per_page = 50


@admin.register(WeeklyMenuTemplate)
class WeeklyMenuTemplateAdmin(admin.ModelAdmin):
    list_display = ('day_of_week_display', 'meal_type', 'name', 'cost', 'is_active')
    list_filter = ('day_of_week', 'meal_type', 'is_active')
    search_fields = ('name',)
    ordering = ('day_of_week', 'meal_type')
    list_per_page = 50
    
    def day_of_week_display(self, obj):
        return obj.get_day_of_week_display()
    day_of_week_display.short_description = 'Day of Week'
    
    def get_urls(self):
        urls = super().get_urls()
        custom_urls = [
            path('generate-meals/', self.admin_site.admin_view(self.generate_meals_view), name='core_generate_meals'),
        ]
        return custom_urls + urls
    
    def generate_meals_view(self, request):
        """View to generate meals from templates for a specified date range."""
        if request.method == 'POST':
            weeks = int(request.POST.get('weeks', 2))
            start_date = date.today()
            
            created_count = 0
            for week in range(weeks):
                for day in range(7):
                    current_date = start_date + timedelta(days=week*7 + day)
                    day_of_week = current_date.weekday()
                    
                    templates = WeeklyMenuTemplate.objects.filter(
                        day_of_week=day_of_week,
                        is_active=True
                    )
                    
                    for template in templates:
                        meal, created = MealItem.objects.get_or_create(
                            date=current_date,
                            meal_type=template.meal_type,
                            defaults={
                                'name': template.name,
                                'cost': template.cost,
                                'is_active': True,
                                'from_template': True,
                            }
                        )
                        if created:
                            created_count += 1
            
            messages.success(request, f'Successfully generated {created_count} meals for the next {weeks} weeks.')
            return redirect('..')
        
        context = {
            'title': 'Generate Meals from Weekly Template',
            'templates': WeeklyMenuTemplate.objects.filter(is_active=True).order_by('day_of_week', 'meal_type'),
        }
        return render(request, 'admin/core/generate_meals.html', context)


@admin.register(MealItem)
class MealItemAdmin(admin.ModelAdmin):
    list_display = ('date', 'meal_type', 'name', 'cost', 'is_active', 'from_template_badge')
    list_filter = ('date', 'meal_type', 'is_active', 'from_template')
    search_fields = ('name',)
    ordering = ('-date', 'meal_type')
    list_per_page = 50
    date_hierarchy = 'date'
    actions = ['mark_as_active', 'mark_as_inactive']
    
    def from_template_badge(self, obj):
        if obj.from_template:
            return mark_safe('<span style="color: green;">✓ Auto</span>')
        return mark_safe('<span style="color: blue;">✎ Manual</span>')
    from_template_badge.short_description = 'Source'
    
    def mark_as_active(self, request, queryset):
        updated = queryset.update(is_active=True)
        self.message_user(request, f'{updated} meals marked as active.')
    mark_as_active.short_description = 'Mark selected meals as active'
    
    def mark_as_inactive(self, request, queryset):
        updated = queryset.update(is_active=False)
        self.message_user(request, f'{updated} meals marked as inactive.')
    mark_as_inactive.short_description = 'Mark selected meals as inactive'
    
    def changelist_view(self, request, extra_context=None):
        extra_context = extra_context or {}
        extra_context['generate_meals_url'] = '../weeklymenutemplate/generate-meals/'
        return super().changelist_view(request, extra_context)


@admin.register(SkippedMeal)
class SkippedMealAdmin(admin.ModelAdmin):
    list_display = ('user', 'meal_item', 'created_at')
    list_filter = ('meal_item__date', 'meal_item__meal_type', 'created_at')
    search_fields = ('user__username', 'meal_item__name')
    readonly_fields = ('created_at',)
    list_per_page = 50
    date_hierarchy = 'created_at'
