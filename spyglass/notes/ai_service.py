import google.generativeai as genai
import json
import logging
from django.conf import settings

logger = logging.getLogger(__name__)

class GeminiAIService:
    def __init__(self):
        if not settings.GEMINI_API_KEY:
            raise ValueError("Gemini API key not configured")
        
        genai.configure(api_key=settings.GEMINI_API_KEY)
        # Fix: Use the correct model name
        self.model = genai.GenerativeModel('gemini-1.5-pro')  # Changed from 'gemini-pro'
        logger.info("Gemini AI service initialized successfully")
    
    def analyze_content_security(self, content):
        print(f"🔍 STARTING ANALYSIS FOR: {content}")
        
        prompt = f"""
        You are a cybersecurity expert for SpyGlass, a self-destructing notes app. 
        
        Analyze this content: "{content}"
        
        Based on your expertise, determine:
        1. How sensitive is this content?
        2. What security risks does it pose?
        3. How should it be protected?
        
        Provide your analysis in JSON format with these fields:
        - risk_level: Your assessment (any level you think fits)
        - max_views: How many people should see this (1-10)
        - expiry_minutes: How long it should last (1 minute to 7 days)
        - reasoning: Your expert analysis (keep under 100 words)
        - content_type: What type of content this is
        - security_advice: Your professional recommendation (keep under 50 words)
        
        Be creative with your analysis but keep explanations concise. Trust your cybersecurity instincts.
        
        Return only valid JSON without markdown formatting.
        """
        
        try:
            print("📡 CALLING GEMINI API...")
            response = self.model.generate_content(prompt)
            print(f"📥 RAW GEMINI RESPONSE:")
            print(response.text)
            print("="*50)
            
            # Clean the response - remove markdown code blocks
            response_text = response.text.strip()
            if response_text.startswith('```json'):
                response_text = response_text[7:]  # Remove ```json
            if response_text.startswith('```'):
                response_text = response_text[3:]   # Remove ```
            if response_text.endswith('```'):
                response_text = response_text[:-3]  # Remove ending ```
            
            response_text = response_text.strip()
            print(f"🧹 CLEANED RESPONSE:")
            print(response_text)
            print("="*50)
            
            ai_analysis = json.loads(response_text)
            print(f"✅ PARSED JSON SUCCESSFULLY:")
            print(ai_analysis)
            return ai_analysis
            
        except json.JSONDecodeError as e:
            print(f"❌ JSON PARSE ERROR: {str(e)}")
            print(f"❌ CLEANED RESPONSE WAS: {response_text}")
            raise
        except Exception as e:
            print(f"❌ GEMINI ERROR: {str(e)}")
            raise
    
    def generate_key_hint_suggestions(self, user_hint):
        """
        Generate better encryption key hints - NO FALLBACK
        """
        logger.info(f"Generating hint suggestions for: {user_hint}")
        
        prompt = f"""
        A user wants to create an encryption key hint: "{user_hint}"
        
        Suggest 3 improved versions that are:
        - More specific and memorable
        - Secure (not easily guessable by strangers)
        - Clear for the intended recipient
        
        Respond with ONLY a valid JSON array:
        ["improved hint 1", "improved hint 2", "improved hint 3"]
        """
        
        try:
            logger.info("Sending hint request to Gemini API...")
            response = self.model.generate_content(prompt)
            logger.info(f"Received hint response: {response.text}")
            
            suggestions = json.loads(response.text.strip())
            if not isinstance(suggestions, list):
                raise ValueError("Response is not a list")
            
            logger.info("Successfully generated hint suggestions")
            return suggestions
            
        except json.JSONDecodeError as e:
            logger.error(f"JSON decode error in hints: {str(e)}")
            logger.error(f"Raw response was: {response.text}")
            raise ValueError(f"Gemini returned invalid JSON: {response.text}")
            
        except Exception as e:
            logger.error(f"Gemini AI hint error: {str(e)}")
            raise Exception(f"Gemini hint generation failed: {str(e)}")
    
    def detect_suspicious_patterns(self, access_logs):
        """
        Analyze access patterns - NO FALLBACK
        """
        if not access_logs:
            return {"threat_level": "NONE", "analysis": "No access logs to analyze"}
        
        logger.info(f"Analyzing {len(access_logs)} access logs")
        
        # Format access logs for AI analysis
        log_summary = self._format_logs_for_ai(access_logs)
        
        prompt = f"""
        Analyze these access logs for suspicious patterns:
        
        {log_summary}
        
        Look for:
        - Multiple failed attempts from same IP
        - Rapid successive attempts
        - Access from unusual locations/patterns
        - Potential brute force attacks
        
        Respond with ONLY valid JSON:
        {{
            "threat_level": "NONE|LOW|MEDIUM|HIGH|CRITICAL",
            "analysis": "Brief description of findings",
            "recommendations": "Security recommendations"
        }}
        """
        
        try:
            logger.info("Sending security analysis request to Gemini...")
            response = self.model.generate_content(prompt)
            logger.info(f"Received security analysis: {response.text}")
            
            analysis = json.loads(response.text.strip())
            logger.info("Successfully analyzed security patterns")
            return analysis
            
        except json.JSONDecodeError as e:
            logger.error(f"JSON decode error in security analysis: {str(e)}")
            logger.error(f"Raw response was: {response.text}")
            raise ValueError(f"Gemini returned invalid JSON: {response.text}")
            
        except Exception as e:
            logger.error(f"Gemini security analysis error: {str(e)}")
            raise Exception(f"Gemini security analysis failed: {str(e)}")
    
    def _format_logs_for_ai(self, access_logs):
        """
        Format access logs for AI analysis
        """
        log_lines = []
        for log in access_logs[:20]:  # Last 20 logs
            log_lines.append(f"IP: {log.ip_address}, Success: {log.was_successful}, Time: {log.accessed_at}, Reason: {log.failure_reason or 'N/A'}")
        
        return "\n".join(log_lines)

# Create singleton instance
try:
    ai_service = GeminiAIService()
    logger.info("AI service singleton created successfully")
except Exception as e:
    logger.error(f"Failed to create AI service: {str(e)}")
    raise