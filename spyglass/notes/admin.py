from django.contrib import admin
from .models import Note, NoteAccess

@admin.register(Note)
class NoteAdmin(admin.ModelAdmin):
    list_display = ['id', 'created_at', 'expires_at', 'current_views', 'max_views', 'is_expired', 'creator_ip']
    list_filter = ['is_expired', 'expiry_minutes', 'created_at']
    search_fields = ['id', 'creator_ip']
    readonly_fields = ['id', 'created_at', 'current_views']

@admin.register(NoteAccess)
class NoteAccessAdmin(admin.ModelAdmin):
    list_display = ['note', 'ip_address', 'accessed_at', 'was_successful', 'failure_reason']
    list_filter = ['was_successful', 'failure_reason', 'accessed_at']
    search_fields = ['note__id', 'ip_address']