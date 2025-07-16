from django.utils.deprecation import MiddlewareMixin
from .models import NoteAccess
import logging

logger = logging.getLogger(__name__)

class IPTrackingMiddleware(MiddlewareMixin):
    def process_request(self, request):
        # Get real IP address
        x_forwarded_for = request.META.get('HTTP_X_FORWARDED_FOR')
        if x_forwarded_for:
            ip = x_forwarded_for.split(',')[0]
        else:
            ip = request.META.get('REMOTE_ADDR')
        
        request.real_ip = ip
        return None