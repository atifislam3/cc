from django.db import models
from django.contrib.auth.models import User


class StudentProfile(models.Model):
    """Student profile linked to a User."""
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='student_profile')
    roll_number = models.CharField(max_length=20)
    room_number = models.CharField(max_length=10)

    def __str__(self):
        return f"{self.user.username} - {self.roll_number}"


class MealItem(models.Model):
    """Represents a meal item available on a specific date."""
    MEAL_TYPE_CHOICES = [
        ('Breakfast', 'Breakfast'),
        ('Lunch', 'Lunch'),
        ('Dinner', 'Dinner'),
    ]

    date = models.DateField()
    meal_type = models.CharField(max_length=10, choices=MEAL_TYPE_CHOICES)
    name = models.CharField(max_length=100)
    cost = models.IntegerField()
    is_active = models.BooleanField(default=True)

    class Meta:
        unique_together = ('date', 'meal_type')

    def __str__(self):
        return f"{self.date} - {self.meal_type}: {self.name}"


class SkippedMeal(models.Model):
    """Records when a user skips a specific meal."""
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='skipped_meals')
    meal_item = models.ForeignKey(MealItem, on_delete=models.CASCADE, related_name='skipped_by')
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ('user', 'meal_item')

    def __str__(self):
        return f"{self.user.username} skipped {self.meal_item}"
