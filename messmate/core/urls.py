from django.urls import path
from . import views

urlpatterns = [
    path('', views.dashboard_view, name='dashboard'),
    path('register/', views.register_view, name='register'),
    path('login/', views.login_view, name='login'),
    path('logout/', views.logout_view, name='logout'),
    path('skip/<int:meal_id>/', views.skip_meal_view, name='skip_meal'),
    path('history/', views.menu_history_view, name='menu_history'),
    path('stats/', views.manager_stats_view, name='manager_stats'),
]
