from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.exceptions import NotFound
from django.shortcuts import get_object_or_404
from django.utils import timezone
from django.db import models
from .models import Note, NoteAccess
from .serializers import (
    NoteCreateSerializer, 
    NoteRetrieveSerializer, 
    NoteStatusSerializer,
    NoteAccessSerializer
)
from .ai_service import ai_service

class NoteViewSet(viewsets.ModelViewSet):
    
    def get_queryset(self):
        """
        Base queryset with security and performance optimizations.
        Automatically filters out expired notes and applies access control.
        """
        queryset = Note.objects.select_related().prefetch_related('access_logs')
        queryset = queryset.filter(is_expired=False)
        queryset = queryset.order_by('-created_at')
        return queryset
    
    def get_object(self):
        """
        Override get_object to add additional security checks
        and automatically handle expired notes.
        """
        queryset = self.get_queryset()
        pk = self.kwargs.get('pk')
        
        try:
            note = queryset.get(pk=pk)
        except Note.DoesNotExist:
            try:
                expired_note = Note.objects.get(pk=pk)
                if expired_note.is_expired or not expired_note.is_accessible():
                    raise NotFound('Note has expired or is no longer accessible')
            except Note.DoesNotExist:
                pass
            raise NotFound('Note not found')
        
        if not note.is_accessible():
            raise NotFound('Note has expired or reached maximum views')
        
        return note
    
    def get_serializer_class(self):
        if self.action == 'create':
            return NoteCreateSerializer
        elif self.action == 'retrieve':
            return NoteRetrieveSerializer
        elif self.action == 'status':
            return NoteStatusSerializer
        return NoteRetrieveSerializer
    
    def create(self, request, *args, **kwargs):
        """Create a new encrypted note"""
        serializer = self.get_serializer(data=request.data, context={'request': request})
        serializer.is_valid(raise_exception=True)
        note = serializer.save()
        
        response_serializer = NoteStatusSerializer(note)
        return Response({
            **response_serializer.data,
            'link': f'/api/notes/{note.id}/',
            'status_link': f'/api/notes/{note.id}/status/',
            'message': 'Note created successfully'
        }, status=status.HTTP_201_CREATED)
    
    def retrieve(self, request, *args, **kwargs):
        """Retrieve and decrypt a note (increments view count)"""
        note = self.get_object()
        
        if not note.is_accessible():
            self.log_access(request, note, False, "expired_or_max_views")
            return Response({
                'error': 'Note has expired or reached maximum views',
                'expired': True
            }, status=status.HTTP_410_GONE)
        
        self.log_access(request, note, True)
        note.increment_view()
        
        serializer = self.get_serializer(note)
        return Response(serializer.data)
    
    @action(detail=True, methods=['get'])
    def status(self, request, pk=None):
        """Get note status without incrementing view count"""
        note = get_object_or_404(Note, pk=pk)
        serializer = NoteStatusSerializer(note)
        return Response(serializer.data)
    
    @action(detail=True, methods=['get'])
    def access_logs(self, request, pk=None):
        """Get access logs for a note"""
        note = get_object_or_404(Note, pk=pk)
        logs = note.access_logs.all()[:50]
        serializer = NoteAccessSerializer(logs, many=True)
        return Response(serializer.data)
    
    @action(detail=False, methods=['post'])
    def cleanup_expired(self, request):
        """Manually cleanup expired notes"""
        from django.db.models import Q
        
        time_expired_count = Note.objects.filter(
            expires_at__lt=timezone.now(),
            is_expired=False
        ).update(is_expired=True)
        
        view_expired_count = Note.objects.filter(
            current_views__gte=models.F('max_views'),
            is_expired=False
        ).update(is_expired=True)
        
        old_threshold = timezone.now() - timezone.timedelta(days=7)
        deleted_count = Note.objects.filter(
            is_expired=True,
            expires_at__lt=old_threshold
        ).delete()[0]
        
        return Response({
            'time_expired': time_expired_count,
            'view_expired': view_expired_count,
            'deleted_old': deleted_count,
            'message': f'Cleanup complete: {time_expired_count + view_expired_count} notes expired, {deleted_count} old notes deleted'
        })
    
    # NEW AI-POWERED ENDPOINTS
    
    @action(detail=False, methods=['post'])
    def ai_analyze_content(self, request):
        """
        🤖 AI analyzes content and suggests optimal security settings
        """
        content = request.data.get('content', '')
        
        if not content.strip():
            return Response({
                'error': 'Content is required for analysis'
            }, status=status.HTTP_400_BAD_REQUEST)
        
        try:
            analysis = ai_service.analyze_content_security(content)
            
            return Response({
                'ai_analysis': analysis,
                'suggested_settings': {
                    'max_views': analysis.get('max_views', 1),
                    'expiry_minutes': analysis.get('expiry_minutes', 60)
                },
                'message': '🤖 AI analysis completed successfully'
            })
        
        except Exception as e:
            return Response({
                'error': f'AI analysis failed: {str(e)}',
                'fallback_settings': {
                    'max_views': 1,
                    'expiry_minutes': 60
                }
            }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
    
    @action(detail=False, methods=['post'])
    def ai_improve_hint(self, request):
        """
        🤖 AI generates improved encryption key hints
        """
        user_hint = request.data.get('hint', '')
        
        if not user_hint.strip():
            return Response({
                'error': 'Hint is required for improvement'
            }, status=status.HTTP_400_BAD_REQUEST)
        
        try:
            suggestions = ai_service.generate_key_hint_suggestions(user_hint)
            
            return Response({
                'original_hint': user_hint,
                'ai_suggestions': suggestions,
                'message': '🤖 Hint improvements generated'
            })
        
        except Exception as e:
            return Response({
                'error': f'Hint improvement failed: {str(e)}',
                'original_hint': user_hint
            }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
    
    @action(detail=True, methods=['get'])
    def ai_security_analysis(self, request, pk=None):
        """
        🤖 AI analyzes access patterns for suspicious activity
        """
        note = get_object_or_404(Note, pk=pk)
        logs = note.access_logs.all()[:50]
        
        try:
            threat_analysis = ai_service.detect_suspicious_patterns(logs)
            
            return Response({
                'note_id': note.id,
                'total_access_attempts': logs.count(),
                'ai_threat_analysis': threat_analysis,
                'message': '🤖 Security analysis completed'
            })
        
        except Exception as e:
            return Response({
                'error': f'Security analysis failed: {str(e)}',
                'note_id': note.id
            }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
    
    def log_access(self, request, note, was_successful, failure_reason=None):
        """Log note access attempt with optional failure reason"""
        NoteAccess.objects.create(
            note=note,
            ip_address=getattr(request, 'real_ip', request.META.get('REMOTE_ADDR')),
            user_agent=request.META.get('HTTP_USER_AGENT', ''),
            was_successful=was_successful,
            failure_reason=failure_reason
        )
    # In your views.py, add this test endpoint temporarily:
    @action(detail=False, methods=['get'])
    def test_ai_setup(self, request):
        from django.conf import settings
        return Response({
            'api_key_loaded': bool(settings.GEMINI_API_KEY),
            'api_key_starts_with': settings.GEMINI_API_KEY[:10] if settings.GEMINI_API_KEY else 'None',
            'ai_service_available': bool(ai_service.model)
        })

# In your views.py, add this test endpoint temporarily:
