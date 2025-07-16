from django.urls import path
from drf_yasg.views import get_schema_view
from drf_yasg import openapi
from rest_framework import permissions

schema_view = get_schema_view(
    openapi.Info(
        title="SpyGlass API",
        default_version='v1',
        description="Encrypted Self-Destructing Notes API",
        terms_of_service="https://www.google.com/policies/terms/",
        contact=openapi.Contact(email="admin@spyglass.com"),
        license=openapi.License(name="MIT License"),
    ),
    public=True,
    permission_classes=(permissions.AllowAny,),
)
