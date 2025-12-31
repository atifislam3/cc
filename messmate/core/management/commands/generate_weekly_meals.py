from django.core.management.base import BaseCommand
from django.utils import timezone
from datetime import date, timedelta
from core.models import WeeklyMenuTemplate, MealItem


class Command(BaseCommand):
    help = 'Generate meals from weekly menu templates'

    def add_arguments(self, parser):
        parser.add_argument(
            '--weeks',
            type=int,
            default=2,
            help='Number of weeks to generate meals for (default: 2)'
        )

    def handle(self, *args, **options):
        weeks = options['weeks']
        start_date = date.today()
        
        self.stdout.write(self.style.SUCCESS(f'Generating meals for {weeks} weeks starting from {start_date}...'))
        
        created_count = 0
        skipped_count = 0
        
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
                        self.stdout.write(
                            self.style.SUCCESS(
                                f'Created: {current_date} - {template.meal_type} - {template.name}'
                            )
                        )
                    else:
                        skipped_count += 1
        
        self.stdout.write(
            self.style.SUCCESS(
                f'\nCompleted! Created {created_count} meals, skipped {skipped_count} existing meals.'
            )
        )
