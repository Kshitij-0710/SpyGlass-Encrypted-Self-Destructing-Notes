from django.db import models
from django.utils import timezone
from datetime import timedelta
import uuid

class Note(models.Model):
    EXPIRY_CHOICES = [
        (5, '5 minutes'),
        (15, '15 minutes'),
        (30, '30 minutes'),
        (60, '1 hour'),
        (360, '6 hours'),
        (1440, '24 hours'),
        (10080, '7 days'),
    ]
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    encrypted_content = models.TextField()  # Base64 encoded encrypted content
    encryption_key_hint = models.CharField(max_length=100, blank=True)  # Optional hint for key
    created_at = models.DateTimeField(auto_now_add=True)
    expires_at = models.DateTimeField()
    expiry_minutes = models.IntegerField(choices=EXPIRY_CHOICES, default=60)
    max_views = models.IntegerField(default=1)  # Self-destruct after N views
    current_views = models.IntegerField(default=0)
    is_expired = models.BooleanField(default=False)
    creator_ip = models.GenericIPAddressField(null=True, blank=True)
    
    class Meta:
        ordering = ['-created_at']
    
    def save(self, *args, **kwargs):
        if not self.expires_at:
            self.expires_at = timezone.now() + timedelta(minutes=self.expiry_minutes)
        super().save(*args, **kwargs)
    
    def is_accessible(self):
        """Check if note is still accessible"""
        print(f"🔍 Django: Checking accessibility for note {self.id}")
        print(f"🔍 Django: is_expired = {self.is_expired}")
        print(f"🔍 Django: timezone.now() = {timezone.now()}")
        print(f"🔍 Django: expires_at = {self.expires_at}")
        print(f"🔍 Django: current_views = {self.current_views}")
        print(f"🔍 Django: max_views = {self.max_views}")
        print(f"🔍 Django: current_views >= max_views = {self.current_views >= self.max_views}")
        
        if self.is_expired:
            print("🔍 Django: Returning False - already marked expired")
            return False
        if timezone.now() > self.expires_at:
            print("🔍 Django: Returning False - time expired")
            self.is_expired = True
            self.save()
            return False
        if self.current_views >= self.max_views:
            print("🔍 Django: Returning False - max views reached")
            self.is_expired = True
            self.save()
            return False
        
        print("🔍 Django: Returning True - note is accessible")
        return True
    
    def increment_view(self):
        """Increment view count and check for self-destruction"""
        self.current_views += 1
        if self.current_views >= self.max_views:
            self.is_expired = True
        self.save()

class NoteAccess(models.Model):
    note = models.ForeignKey(Note, on_delete=models.CASCADE, related_name='access_logs')
    ip_address = models.GenericIPAddressField()
    user_agent = models.TextField(blank=True)
    accessed_at = models.DateTimeField(auto_now_add=True)
    was_successful = models.BooleanField(default=True)
    failure_reason = models.CharField(max_length=50, blank=True, null=True)  # ← NEW FIELD
    
    class Meta:
        ordering = ['-accessed_at']