"""songsDB URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/2.0/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path
from django.conf.urls import include
from django.contrib.auth import views as auth_views
from django.contrib.auth.forms import AuthenticationForm

from django.conf import settings
from django.conf.urls.static import static

from songs import views


urlpatterns = [
    path('admin/', admin.site.urls),
    path("", include("songs.urls")),
    path("login/", auth_views.login, {"template_name": "registration/login.html", "authentication_form": AuthenticationForm}, name="login"),
    path("user/sign-up/", views.user_sign_up, name="user_sign_up"),
    path("user/create-account", views.create_account, name="create_account"),
    path("accounts/", include("django.contrib.auth.urls")),
    # path("accounts/", include("allauth.urls")),
    path("profile/<username>", views.user_display_profile, name="user_display_profile"),
    path("profile/change_username/", views.change_username, name="change_username"),
    path("profile/change_password/", views.change_password, name="change_password"),

    #for social auth
    path('accounts/', include('social_django.urls', namespace='social')),


]

urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
 

# Customising Django Admin Site

admin.site.site_header = "Songs Database Administration"
admin.site.index_title = "Songs Database"
admin.site.site_title = "Songs Database"