from django.contrib import admin
from .models import StudentProfile, MealItem, SkippedMeal


@admin.register(StudentProfile)
class StudentProfileAdmin(admin.ModelAdmin):
    list_display = ('user', 'roll_number', 'room_number')
    search_fields = ('user__username', 'roll_number', 'room_number')


@admin.register(MealItem)
class MealItemAdmin(admin.ModelAdmin):
    list_display = ('date', 'meal_type', 'name', 'cost', 'is_active')
    list_filter = ('date', 'meal_type', 'is_active')
    search_fields = ('name',)
    ordering = ('-date', 'meal_type')


@admin.register(SkippedMeal)
class SkippedMealAdmin(admin.ModelAdmin):
    list_display = ('user', 'meal_item', 'created_at')
    list_filter = ('meal_item__date', 'meal_item__meal_type')
    search_fields = ('user__username',)
