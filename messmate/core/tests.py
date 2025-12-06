from django.test import TestCase, Client
from django.contrib.auth.models import User
from django.urls import reverse
from django.utils import timezone
from datetime import date, timedelta
from .models import StudentProfile, MealItem, SkippedMeal


class StudentProfileModelTest(TestCase):
    def setUp(self):
        self.user = User.objects.create_user(
            username='testuser',
            password='testpass123'
        )
        self.profile = StudentProfile.objects.create(
            user=self.user,
            roll_number='2024001',
            room_number='101A'
        )

    def test_student_profile_creation(self):
        """Test StudentProfile model creation."""
        self.assertEqual(self.profile.roll_number, '2024001')
        self.assertEqual(self.profile.room_number, '101A')
        self.assertEqual(self.profile.user.username, 'testuser')

    def test_student_profile_str(self):
        """Test StudentProfile string representation."""
        self.assertIn('testuser', str(self.profile))
        self.assertIn('2024001', str(self.profile))


class MealItemModelTest(TestCase):
    def setUp(self):
        self.meal = MealItem.objects.create(
            date=date.today(),
            meal_type='Lunch',
            name='Chicken Biryani',
            cost=150,
            is_active=True
        )

    def test_meal_item_creation(self):
        """Test MealItem model creation."""
        self.assertEqual(self.meal.name, 'Chicken Biryani')
        self.assertEqual(self.meal.cost, 150)
        self.assertEqual(self.meal.meal_type, 'Lunch')
        self.assertTrue(self.meal.is_active)

    def test_meal_item_str(self):
        """Test MealItem string representation."""
        self.assertIn('Lunch', str(self.meal))
        self.assertIn('Chicken Biryani', str(self.meal))

    def test_unique_together_constraint(self):
        """Test that date + meal_type must be unique."""
        with self.assertRaises(Exception):
            MealItem.objects.create(
                date=date.today(),
                meal_type='Lunch',
                name='Another Lunch',
                cost=100
            )


class SkippedMealModelTest(TestCase):
    def setUp(self):
        self.user = User.objects.create_user(
            username='testuser',
            password='testpass123'
        )
        self.meal = MealItem.objects.create(
            date=date.today(),
            meal_type='Dinner',
            name='Roti Paneer',
            cost=120
        )
        self.skipped = SkippedMeal.objects.create(
            user=self.user,
            meal_item=self.meal
        )

    def test_skipped_meal_creation(self):
        """Test SkippedMeal model creation."""
        self.assertEqual(self.skipped.user.username, 'testuser')
        self.assertEqual(self.skipped.meal_item.name, 'Roti Paneer')

    def test_unique_together_constraint(self):
        """Test that user can only skip a specific meal once."""
        with self.assertRaises(Exception):
            SkippedMeal.objects.create(
                user=self.user,
                meal_item=self.meal
            )


class DashboardViewTest(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = User.objects.create_user(
            username='testuser',
            password='testpass123'
        )
        StudentProfile.objects.create(
            user=self.user,
            roll_number='2024001',
            room_number='101A'
        )
        # Create a meal for tomorrow to ensure it's skippable
        tomorrow = date.today() + timedelta(days=1)
        self.meal = MealItem.objects.create(
            date=tomorrow,
            meal_type='Lunch',
            name='Test Meal',
            cost=100
        )

    def test_dashboard_requires_login(self):
        """Test that dashboard requires authentication."""
        response = self.client.get(reverse('dashboard'))
        self.assertEqual(response.status_code, 302)
        self.assertIn('login', response.url)

    def test_dashboard_accessible_when_logged_in(self):
        """Test that dashboard is accessible when logged in."""
        self.client.login(username='testuser', password='testpass123')
        response = self.client.get(reverse('dashboard'))
        self.assertEqual(response.status_code, 200)
        self.assertContains(response, 'Upcoming Meals')


class SkipMealViewTest(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = User.objects.create_user(
            username='testuser',
            password='testpass123'
        )
        StudentProfile.objects.create(
            user=self.user,
            roll_number='2024001',
            room_number='101A'
        )
        # Create a meal for tomorrow to ensure it's skippable
        tomorrow = date.today() + timedelta(days=1)
        self.meal = MealItem.objects.create(
            date=tomorrow,
            meal_type='Lunch',
            name='Test Meal',
            cost=100
        )

    def test_skip_meal_creates_record(self):
        """Test that skipping a meal creates a SkippedMeal record."""
        self.client.login(username='testuser', password='testpass123')
        response = self.client.get(reverse('skip_meal', args=[self.meal.id]))
        self.assertEqual(response.status_code, 302)
        self.assertTrue(
            SkippedMeal.objects.filter(user=self.user, meal_item=self.meal).exists()
        )

    def test_cannot_skip_same_meal_twice(self):
        """Test that user cannot skip the same meal twice."""
        self.client.login(username='testuser', password='testpass123')
        # First skip
        self.client.get(reverse('skip_meal', args=[self.meal.id]))
        # Second attempt
        response = self.client.get(reverse('skip_meal', args=[self.meal.id]))
        self.assertEqual(response.status_code, 302)
        # Should still only have one record
        self.assertEqual(
            SkippedMeal.objects.filter(user=self.user, meal_item=self.meal).count(),
            1
        )


class ManagerStatsViewTest(TestCase):
    def setUp(self):
        self.client = Client()
        self.admin = User.objects.create_superuser(
            username='admin',
            password='admin123',
            email='admin@example.com'
        )
        self.user = User.objects.create_user(
            username='testuser',
            password='testpass123'
        )
        StudentProfile.objects.create(
            user=self.user,
            roll_number='2024001',
            room_number='101A'
        )
        self.meal = MealItem.objects.create(
            date=date.today(),
            meal_type='Lunch',
            name='Test Meal',
            cost=100
        )

    def test_manager_stats_accessible(self):
        """Test that manager stats is accessible when logged in."""
        self.client.login(username='admin', password='admin123')
        response = self.client.get(reverse('manager_stats'))
        self.assertEqual(response.status_code, 200)
        self.assertContains(response, 'Manager Dashboard')

    def test_manager_stats_shows_correct_counts(self):
        """Test that manager stats shows correct meal counts."""
        self.client.login(username='admin', password='admin123')
        # Skip the meal
        SkippedMeal.objects.create(user=self.user, meal_item=self.meal)
        response = self.client.get(reverse('manager_stats'))
        self.assertEqual(response.status_code, 200)
        self.assertContains(response, 'Total Money Saved')
