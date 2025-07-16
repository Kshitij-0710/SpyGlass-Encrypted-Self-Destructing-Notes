from rest_framework import serializers
from .models import Note, NoteAccess
from django.utils import timezone

class NoteCreateSerializer(serializers.ModelSerializer):
    class Meta:
        model = Note
        fields = ['encrypted_content', 'encryption_key_hint', 'expiry_minutes', 'max_views']
    
    def create(self, validated_data):
        # Get IP from request context
        request = self.context.get('request')
        if request:
            x_forwarded_for = request.META.get('HTTP_X_FORWARDED_FOR')
            if x_forwarded_for:
                ip = x_forwarded_for.split(',')[0]
            else:
                ip = request.META.get('REMOTE_ADDR')
            validated_data['creator_ip'] = ip
        
        return super().create(validated_data)

class NoteRetrieveSerializer(serializers.ModelSerializer):
    time_remaining = serializers.SerializerMethodField()
    views_remaining = serializers.SerializerMethodField()
    is_accessible = serializers.SerializerMethodField()  # Add this
    
    class Meta:
        model = Note
        fields = ['id', 'encrypted_content', 'encryption_key_hint', 'created_at', 
                 'expires_at', 'max_views', 'current_views', 'time_remaining', 'views_remaining',
                 'is_accessible', 'is_expired']  # Add these two fields
        read_only_fields = ['id', 'created_at', 'expires_at', 'current_views', 'is_expired']
    
    def get_time_remaining(self, obj):
        if obj.expires_at > timezone.now():
            delta = obj.expires_at - timezone.now()
            return int(delta.total_seconds())
        return 0
    
    def get_views_remaining(self, obj):
        return max(0, obj.max_views - obj.current_views)
    
    def get_is_accessible(self, obj):  # Add this method
        result = obj.is_accessible()
        print(f"🔍 Retrieve Serializer: get_is_accessible() returned: {result}")
        return result

class NoteStatusSerializer(serializers.ModelSerializer):
    time_remaining = serializers.SerializerMethodField()
    views_remaining = serializers.SerializerMethodField()
    is_accessible = serializers.SerializerMethodField()
    
    class Meta:
        model = Note
        fields = ['id', 'created_at','encryption_key_hint', 'expires_at', 'max_views', 'current_views', 
                 'time_remaining', 'views_remaining', 'is_accessible', 'is_expired']
        read_only_fields = ['id', 'created_at', 'expires_at', 'max_views', 'current_views', 'is_expired']
    
    def get_time_remaining(self, obj):
        if obj.expires_at > timezone.now():
            delta = obj.expires_at - timezone.now()
            return int(delta.total_seconds())
        return 0
    
    def get_views_remaining(self, obj):
        return max(0, obj.max_views - obj.current_views)
    
    def get_is_accessible(self, obj):
        return obj.is_accessible()

class NoteAccessSerializer(serializers.ModelSerializer):
    class Meta:
        model = NoteAccess
        fields = ['ip_address', 'user_agent', 'accessed_at', 'was_successful', 'failure_reason']
        read_only_fields = ['ip_address', 'user_agent', 'accessed_at', 'was_successful', 'failure_reason']