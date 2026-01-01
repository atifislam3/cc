# MessMate - Hostel Food Management System

A professional Django-based web application designed to reduce food waste in university hostels by allowing students to opt-out of meals and helping kitchen staff plan food preparation accurately.

## Features

### For Students
- **Professional Dashboard**: Modern gradient UI with upcoming meals display
- **Smart Meal Skipping**: Skip meals up to 2 hours before meal time
- **Personal Savings Tracker**: View your skipped meals history and total savings
- **Responsive Design**: Bootstrap 5 with gradient cards and smooth animations

### For Managers/Warden/Chef (Staff Users)
- **Separate Manager Dashboard**: Accessible at `/manager/` (staff-only access)
- **Kitchen Planning**: View exact meal counts needed (To Cook = Total Students - Skipped Count)
- **Daily Statistics**: Total students, skipped count, and money saved
- **Weekly Menu Templates**: Set up repeating weekly menu that auto-generates meals
- **Bulk Actions**: Mark multiple meals as active/inactive

### For Administrators
- **User Management**: Create accounts for students and managers via admin panel
- **Weekly Menu Setup**: Define 21 templates (7 days × 3 meals) for automated meal generation
- **Access Control**: Manage staff permissions to control manager dashboard access

## URLs and Access

- **Student Dashboard**: `http://localhost:8000/` (logged-in students)
- **Manager Dashboard**: `http://localhost:8000/manager/` (staff users only)
- **Login**: `http://localhost:8000/login/`
- **Menu History**: `http://localhost:8000/history/`
- **Admin Panel**: `http://localhost:8000/admin/`

## Setup and Installation

### 1. Install Dependencies
```bash
pip install django
```

### 2. Run Migrations
```bash
cd messmate
python manage.py migrate
```

### 3. Create Superuser (Admin)
```bash
python manage.py createsuperuser
```

### 4. Run Development Server
```bash
python manage.py runserver
```

### 5. Access the Application
- **Student Interface**: http://localhost:8000/
- **Manager Dashboard**: http://localhost:8000/manager/ (requires staff status)
- **Admin Interface**: http://localhost:8000/admin/

## User Management

### Creating Student and Manager Accounts

**Public registration is disabled.** Only administrators can create user accounts to ensure proper control over system access.

#### Creating a Student Account
1. Log in to the admin panel at `/admin/`
2. Navigate to **Users** under "Authentication and Authorization"
3. Click **Add User**
4. Enter username and password (twice)
5. Click **Save and continue editing**
6. Fill in student details:
   - **Personal info**: First name, Last name, Email (optional)
   - **Student Profile**: Roll Number and Room Number
7. **Permissions**: Leave "Staff status" and "Superuser status" unchecked for regular students
8. Click **Save**

#### Creating a Manager Account
Follow the same steps as above, but:
- Check **Staff status** to give access to Manager Stats dashboard
- Leave "Superuser status" unchecked (unless you want them to have admin access)

#### Providing Credentials to Users
After creating an account:
1. Share the username and initial password with the user
2. Direct them to: http://localhost:8000/login/
3. Recommend they change their password after first login (via admin panel)

## Weekly Menu Management

### Setting Up Weekly Menu Template

1. Log in to the admin panel at `/admin/`
2. Navigate to **Weekly menu templates**
3. Add a template for each meal you want to repeat weekly:
   - Select **Day of week** (Monday-Sunday)
   - Select **Meal type** (Breakfast, Lunch, Dinner)
   - Enter **Name** (e.g., "Chicken Biryani")
   - Enter **Cost** (e.g., 150)
   - Mark as **Active**

Example weekly template:
- Monday Breakfast: Idli Sambar (₹50)
- Monday Lunch: Chicken Biryani (₹150)
- Monday Dinner: Roti Paneer (₹120)
- Tuesday Breakfast: Paratha (₹60)
- ... (and so on for all 7 days)

### Generating Meals from Template

#### Method 1: Via Admin Interface
1. Go to **Meal items** in admin
2. Click **Generate meals from template** button
3. Select number of weeks (1-8 weeks)
4. Click **Generate Meals**

#### Method 2: Via Management Command (for automation/cron)
```bash
# Generate meals for next 2 weeks (default)
python manage.py generate_weekly_meals

# Generate meals for next 4 weeks
python manage.py generate_weekly_meals --weeks 4
```

#### Method 3: Automated (Setup Cron Job)
Add to crontab to auto-generate meals every Sunday:
```bash
# Run every Sunday at midnight to generate meals for next 2 weeks
0 0 * * 0 cd /path/to/messmate && python manage.py generate_weekly_meals --weeks 2
```

## Key Features

### 1. Weekly Menu Template System
- Define your standard weekly menu once
- Automatically generates meals for multiple weeks
- Won't overwrite manually created or modified meals
- Can be updated anytime for future weeks

### 2. Flexible Meal Management
- **Auto-generated meals**: Created from templates, marked with "✓ Auto"
- **Manual meals**: Created individually, marked with "✎ Manual"
- **Easy editing**: Change any specific day's meal without affecting the template

### 3. Professional Admin Interface
- Date hierarchy for easy navigation
- Bulk actions (mark multiple meals active/inactive)
- Filtering by date, meal type, and source (auto/manual)
- Pagination for better performance

### 4. Smart Skip Logic
- Students can only skip meals 2+ hours before meal time
- Prevents duplicate skips (one skip per meal per student)
- Tracks skip history and calculates savings

## Database Models

### WeeklyMenuTemplate
- Stores the weekly recurring menu pattern
- One record per day-of-week + meal-type combination

### MealItem
- Individual meal instances for specific dates
- Can be auto-generated from templates or manually created
- Tracks whether it came from a template

### StudentProfile
- Links to Django User model
- Stores roll number and room number

### SkippedMeal
- Records when a student skips a meal
- Used to calculate "meals to cook" and savings

## Environment Variables (Production)

Set these environment variables for production deployment:

```bash
DJANGO_SECRET_KEY=your-secret-key-here
DJANGO_DEBUG=False
DJANGO_ALLOWED_HOSTS=yourdomain.com,www.yourdomain.com
```

## Security Features

- Environment variable support for sensitive settings
- CSRF protection enabled
- Password validation
- Login required decorators on all student/manager views
- CodeQL security scanned (no vulnerabilities)

## Testing

Run the test suite:
```bash
python manage.py test
```

All 13 tests covering models and views should pass.

## Workflow

### Initial Setup (One-time)
1. Admin sets up weekly menu templates (21 entries for 7 days × 3 meals)
2. Admin generates meals for next few weeks

### Weekly Operations
1. System auto-generates meals (if cron is set up) OR
2. Admin manually generates meals as needed
3. Students view meals and skip as desired
4. Kitchen staff checks Manager Dashboard for "To Cook" count

### Ongoing Management
- Admin can edit specific meals without affecting templates
- Admin can update templates (affects future generated meals only)
- System continues to operate with existing meals even if templates are changed

## Benefits

✅ **Reduces Food Waste**: Kitchen only prepares needed quantity
✅ **Saves Money**: Tracks total savings from skipped meals
✅ **Professional**: Weekly templates make management efficient
✅ **Flexible**: Can override template for special occasions
✅ **Automated**: Set it up once, runs automatically
✅ **User-Friendly**: Simple interface for students and staff

## Support

For issues or questions, please refer to the Django documentation or contact your system administrator.
