# KINORA — Elite MVP Master Development Prompt
## "Your kin. Always close."

---

# EXECUTIVE SUMMARY

**Product Name:** Kinora  
**Pronunciation:** kih-NOR-ah  
**Tagline:** "Your kin. Always close."  
**Definition:** "Kin" = family/your people | "Ora" = circle/aura — "The circle of your kin"

**Product Type:** Private Family Communication & Connection Platform  
**Target Domain:** eliteal.info  
**Versions:** 
- **Kinora Family Edition** (Private, invite-only via license codes)
- **Kinora Public Edition** (Marketplace version - future release)

---

# CORE CONCEPT

Kinora is a premium, private family communication platform that combines messaging, video calling, family heritage preservation, and real-time connection features. Unlike public social media, Kinora is exclusively for invited family members who enter a unique license code before registration.

**The Problem:** Families are scattered across the world. WhatsApp groups get cluttered. Family history gets lost. Staying connected feels like work.

**The Solution:** Kinora — one private space where your entire family lives digitally, with tools designed specifically for family connection, heritage preservation, and communication across languages and borders.

---

# AUTHENTICATION & ACCESS CONTROL

## License Code System (CRITICAL)

### How It Works:
1. Administrator (family patriarch/matriarch) generates unique license codes
2. Each code is pre-assigned to a specific family member
3. Code contains embedded metadata:
   - Assigned name
   - Relationship to family tree
   - Birth date
   - Preferred language
   - Any personalized AI context

### Signup Flow:
```
STEP 1: User visits kinora.app (or eliteal.info/family)
STEP 2: Landing page shows "Enter Your Family Code"
STEP 3: User enters code (e.g., "KINORA-MARIA-2024-7X9K")
STEP 4: System validates code → retrieves pre-loaded profile data
STEP 5: User sees: "Welcome, Maria! You've been invited by Bill Asmar"
STEP 6: User completes registration (email, password, profile photo)
STEP 7: User enters app with AI already knowing who they are
```

### License Code Structure:
```
Format: KINORA-[NAME]-[YEAR]-[4-CHAR-UNIQUE]
Example: KINORA-MARIA-2024-7X9K
Example: KINORA-JOSEPH-2024-3M2P
Example: KINORA-GRANDMA-2024-1A1A
```

### Admin Code Management Dashboard:
- Generate new codes
- Assign codes to family members
- Pre-load profile information
- Track: Code created | Code used | Code expired
- Revoke access if needed
- Set expiration dates on unused codes

---

# FEATURE SPECIFICATIONS

## FEATURE 1: Family Chat (Messages, Voice Calls, Video Calls)

### Description:
Simple, clean messaging system designed for families — not cluttered like WhatsApp groups.

### Requirements:
- **Text Messaging:** Real-time, with read receipts, typing indicators
- **Voice Messages:** Tap-and-hold to record, send audio clips
- **Voice Calls:** 1-on-1 and group calls (up to 20 participants)
- **Video Calls:** 1-on-1 and group video (up to 20 participants)
- **Media Sharing:** Photos, videos, documents, voice notes
- **Reactions:** Emoji reactions on messages
- **Reply Threading:** Reply to specific messages
- **Search:** Search message history
- **Pinned Messages:** Pin important messages to top

### Chat Types:
| Type | Description |
|------|-------------|
| Family Hub | Main chat - entire family |
| Direct Messages | Private 1-on-1 conversations |
| Custom Groups | User-created groups (e.g., "Siblings", "Parents", "Cousins") |

### UI/UX:
- Clean, minimal interface
- Large touch targets (elderly users)
- High contrast mode option
- Font size adjustment

---

## FEATURE 2: Interactive Family Tree

### Description:
Visual, navigable family tree starting from grandparents (or earliest known ancestors) down to current generation.

### Requirements:
- **Visual Tree Display:** Hierarchical view showing relationships
- **Multiple Surnames:** Handle married names, maiden names, hyphenated names
- **Profile Cards:** Tap any person to see:
  - Full name (and maiden name if applicable)
  - Photo
  - Birth date
  - Location
  - Relationship path to current user (e.g., "Your father's sister")
  - Bio/notes
  - Contact button (if living member)
- **Deceased Members:** Special styling for passed family members (links to Memorial Page)
- **Relationship Calculator:** "How am I related to [person]?" feature
- **Add/Edit:** Authorized users can add new family members, edit info
- **Export:** Export tree as PDF or image

### Data Structure:
```
Person {
  id: string
  firstName: string
  lastName: string
  maidenName?: string
  birthDate: date
  deathDate?: date
  isDeceased: boolean
  photo: url
  location: string
  bio: text
  parents: [Person.id, Person.id]
  spouses: [Person.id]
  children: [Person.id]
  userId?: string (links to app user if registered)
}
```

---

## FEATURE 3: Live Location Map

### Description:
Real-time map showing where all family members are located around the world.

### Requirements:
- **World Map View:** Interactive map with pins for each family member
- **Real-Time Updates:** Location updates periodically (configurable: 15min, 1hr, manual only)
- **Profile Pins:** Custom pins showing profile photo
- **Tap to Connect:** Tap pin to see profile, send message, or call
- **Privacy Controls:**
  - Share precise location
  - Share city only
  - Share country only
  - Hide location entirely
- **Location History:** Optional - see where family members have been (travel tracking)
- **Proximity Alerts:** "Maria is in your city!" notifications (optional)

### Privacy Settings Per User:
```
locationSharing: "precise" | "city" | "country" | "hidden"
shareWithFamily: boolean
proximityAlerts: boolean
```

---

## FEATURE 4: Birthday Reminders

### Description:
Never miss a family birthday again.

### Requirements:
- **Birthday Calendar:** Visual calendar showing all family birthdays
- **Countdown Widget:** "Maria's birthday in 3 days!"
- **Push Notifications:** 
  - 1 week before
  - 1 day before
  - Day of
- **Birthday Cards:** Send digital birthday cards within app
- **Group Birthday Chat:** Auto-create birthday chat thread on the day
- **Age Display:** Show age they're turning
- **Upcoming List:** Dashboard widget showing next 5 birthdays

---

## FEATURE 5: Notice Blast

### Description:
Important family announcements sent to everyone instantly.

### Requirements:
- **Create Announcement:** Title, message, optional image/video
- **Priority Levels:**
  - 🔴 URGENT (death, emergency, critical health)
  - 🟡 IMPORTANT (birth, wedding, major news)
  - 🔵 GENERAL (reunion planning, updates)
- **Push Notification:** All family members receive instant notification
- **Prominent Display:** Announcements appear at top of app until dismissed
- **Acknowledgment:** Users can mark "Seen" or react
- **Archive:** All past announcements stored and searchable
- **Permissions:** Configurable who can send blasts (everyone vs. admins only)

### Announcement Object:
```
Announcement {
  id: string
  authorId: string
  title: string
  message: text
  media?: url[]
  priority: "urgent" | "important" | "general"
  createdAt: timestamp
  seenBy: [userId]
  reactions: [{userId, emoji}]
}
```

---

## FEATURE 6: Voice Recorder (Notes, Lists, Reminders)

### Description:
Personal voice assistant for capturing thoughts, shopping lists, and reminders.

### Requirements:
- **Voice-to-Text:** Speak and auto-transcribe to text
- **Categories:**
  - Shopping List
  - To-Do List
  - Personal Notes
  - Reminders
- **Reminders:** Set time-based reminders with notification
- **Share Lists:** Share shopping list with family member
- **Collaborative Lists:** Multiple family members can add to same list
- **Check-off Items:** Mark items as complete
- **Voice Playback:** Option to hear original recording

---

## FEATURE 7: Real-Time Call Translator

### Description:
Break language barriers — each person speaks and hears in their preferred language.

### Requirements:
- **Supported Languages:** Minimum 20 languages including:
  - English, Spanish, French, Arabic, Portuguese, German, Italian, Chinese (Mandarin), Japanese, Korean, Russian, Hindi, Tagalog, Vietnamese, Polish, Dutch, Greek, Turkish, Hebrew, Farsi
- **How It Works:**
  1. User A sets language: English
  2. User B sets language: Arabic
  3. User A speaks English → User B hears Arabic
  4. User B speaks Arabic → User A hears English
- **Activation:** Toggle button during call to enable/disable
- **Voice Preservation:** Attempt to maintain tone/emotion in translation
- **Text Translation:** Also works in chat messages
- **Subtitle Mode:** Show translated text on screen during video call

### Technical Approach:
- Speech-to-text (source language)
- Text translation (source → target)
- Text-to-speech (target language)
- Latency target: <2 seconds

---

## FEATURE 8: Memory Vault

### Description:
Preserve family photos and videos with AI tagging and organization.

### Requirements:
- **Upload:** Photos, videos from device or cloud
- **AI Face Recognition:** Auto-detect and tag family members in photos
- **Manual Tagging:** Add names, dates, locations, descriptions
- **Albums:** Create themed albums (Weddings, Holidays, Childhood, etc.)
- **Timeline View:** Browse memories chronologically
- **Search:** Search by person, date, location, or keyword
- **Sharing:** Share individual photos or albums to family chat
- **Download:** Download original quality files
- **Storage:** Generous storage limits (define per plan)

---

## FEATURE 9: Memorial Pages

### Description:
Honor and remember family members who have passed.

### Requirements:
- **Memorial Profile:**
  - Full name and dates (birth - death)
  - Life photo(s)
  - Biography/life story
  - Timeline of life events
  - Photo gallery
  - Video messages from family
- **Tribute Wall:** Family members can post memories, stories, photos
- **Candle Lighting:** Virtual candle lighting feature (symbolic)
- **Anniversary Reminders:** Notifications on death anniversary
- **Link to Family Tree:** Connected to family tree display
- **Privacy:** Viewable only by family members

---

## FEATURE 10: Family Recipes

### Description:
Preserve and share family recipes across generations.

### Requirements:
- **Recipe Cards:**
  - Title
  - Photo(s)
  - Ingredients list
  - Step-by-step instructions
  - Prep time / Cook time
  - Servings
  - Difficulty level
  - Story/origin (e.g., "Grandma's recipe from Lebanon")
  - Submitted by (family member)
- **Categories:** Appetizers, Mains, Desserts, Drinks, Cultural/Holiday
- **Search:** Search by name, ingredient, category
- **Favorites:** Save favorite recipes
- **Print:** Print-friendly format
- **Voice Instructions:** Read recipe aloud while cooking
- **Video Recipes:** Upload cooking videos

---

## FEATURE 11: "On This Day" Memories

### Description:
Daily nostalgia — see what happened in your family on this date in past years.

### Requirements:
- **Daily Notification:** "On This Day" push notification each morning
- **Content Sources:**
  - Photos uploaded on this date
  - Past announcements
  - Birthdays
  - Memorial anniversaries
  - Old chat messages (optional)
- **Display:** Card-style display showing year and content
- **Sharing:** Re-share memories to family chat
- **Opt-out:** Users can disable this feature

---

## FEATURE 12: Prayer/Support Requests

### Description:
When a family member needs support, rally the family.

### Requirements:
- **Create Request:**
  - Title
  - Description
  - Type: Prayer, Financial, Emotional, Physical Help, Other
  - Urgency: Low, Medium, High
- **Notifications:** Family notified of new requests
- **Response Options:**
  - "Praying for you" button
  - Comment with support
  - Offer specific help
- **Privacy Options:**
  - Share with all family
  - Share with specific groups
- **Status Updates:** Requester can update status (ongoing, resolved)
- **Archive:** Past requests stored

---

## FEATURE 13: Shared Photo Albums

### Description:
Collaborative albums where anyone can add photos.

### Requirements:
- **Create Album:** Name, description, cover photo
- **Permissions:**
  - Anyone can add
  - Invite-only contributors
  - View-only for some
- **Upload:** Multiple family members upload to same album
- **Notifications:** Alert when new photos added
- **Comments:** Comment on individual photos
- **Slideshow:** Play album as slideshow
- **Download All:** Download entire album as ZIP

---

## FEATURE 14: Rugby Team Themes (Personalization)

### Description:
Customize the app's appearance based on favorite rugby team.

### Requirements:
- **Team Selection:** User selects favorite team from:
  - Super League
  - Championship
  - NRL
  - International teams
- **Source Data:** https://www.loverugbyleague.com/clubs
- **Theme Application:**
  - App color scheme matches team colors
  - Team logo in header/profile
  - Custom backgrounds
  - Icon styling
- **Multiple Teams:** Option to select 2nd and 3rd favorite teams
- **Seasonal Updates:** Update themes when teams change jerseys
- **Non-Rugby Option:** Neutral theme for those who don't follow rugby

### Team Data to Scrape/Import:
```
Team {
  name: string
  league: string
  primaryColor: hex
  secondaryColor: hex
  logo: url
  stadium: string
  website: url
}
```

---

## FEATURE 15: Rugby Team News Feed

### Description:
Personalized news feed with updates on user's favorite teams.

### Requirements:
- **News Sources:** Aggregate from:
  - Team official websites
  - https://www.loverugbyleague.com
  - Sports news sites
  - Social media (Twitter/X feeds)
- **Personalized Feed:** Show news only for user's selected teams
- **Notification Options:**
  - Match results
  - Breaking news
  - Transfer news
  - Injury updates
- **Match Schedule:** Upcoming matches for favorite teams
- **Live Scores:** Real-time score updates during matches
- **Highlights:** Video highlights when available
- **Share to Family:** Share news articles to family chat

---

# AI INTEGRATION

## Family AI Assistant: "Kino"

### Personality:
- Warm, friendly, family-oriented
- Knows all family members by name and relationship
- Remembers family history and context
- Multilingual capabilities

### Capabilities:
- Answer questions about family members ("Who is Maria's husband?")
- Navigate family tree ("Show me all my cousins")
- Find memories ("Show photos from Christmas 2019")
- Translation assistance
- Recipe suggestions ("What's a good Lebanese dessert recipe from our family?")
- Reminder management
- Event planning assistance
- Relationship calculator ("How is Joseph related to me?")

### Context Awareness:
When user logs in, AI knows:
- User's name
- User's position in family tree
- User's relationships to all other members
- User's preferred language
- User's favorite rugby team
- User's birthday
- Any custom notes from admin

### Example AI Interactions:
```
User: "When is my aunt's birthday?"
Kino: "Your Aunt Maria's birthday is March 15th — that's in 23 days! Would you like me to remind you a week before?"

User: "Show me photos with grandpa"
Kino: "I found 47 photos with Grandpa Joseph. Here are the most recent ones. He appears in photos from 1962 to 2018."

User: "How do I make grandma's kibbeh?"
Kino: "Here's Grandma Miriam's kibbeh recipe, added by your mother in 2019. Would you like me to read the instructions while you cook?"
```

---

# TECHNICAL ARCHITECTURE

## Recommended Stack:

| Layer | Technology |
|-------|------------|
| Frontend Web | React / Next.js |
| Frontend Mobile | React Native (iOS + Android) |
| Backend | Node.js / Express or Python / FastAPI |
| Database | PostgreSQL (primary) + Redis (caching) |
| Real-time | WebSockets (Socket.io) or Firebase Realtime |
| Auth | JWT + OAuth2 (Google, Apple sign-in options) |
| File Storage | AWS S3 or Cloudflare R2 |
| Video/Voice | WebRTC + Twilio or Agora.io |
| Translation | Google Cloud Translation API or DeepL |
| Speech-to-Text | Google Speech-to-Text or Whisper |
| AI/LLM | OpenAI API or Claude API |
| Push Notifications | Firebase Cloud Messaging (FCM) |
| Maps | Google Maps API or Mapbox |
| Hosting | Vercel (frontend) + Railway/Render (backend) or AWS |
| Domain | eliteal.info (GoDaddy) |

## Database Schema Overview:

```
Users
├── id
├── licenseCode
├── email
├── passwordHash
├── firstName
├── lastName
├── maidenName
├── profilePhoto
├── birthDate
├── preferredLanguage
├── favoriteTeam
├── locationSharing
├── currentLocation
├── familyTreePersonId
├── createdAt
├── lastActive

FamilyTreePersons
├── id
├── firstName
├── lastName
├── maidenName
├── birthDate
├── deathDate
├── isDeceased
├── photo
├── bio
├── userId (nullable - links to registered user)

Relationships
├── id
├── personId
├── relatedPersonId
├── relationshipType (parent, child, spouse, sibling)

Messages
├── id
├── chatId
├── senderId
├── content
├── mediaUrls
├── createdAt
├── readBy

Chats
├── id
├── type (family_hub, direct, group)
├── name
├── participants
├── createdAt

Announcements (Notice Blasts)
├── id
├── authorId
├── title
├── message
├── priority
├── mediaUrls
├── seenBy
├── createdAt

Photos
├── id
├── uploaderId
├── url
├── thumbnailUrl
├── taggedPersons
├── albumId
├── takenAt
├── uploadedAt
├── location

Albums
├── id
├── name
├── description
├── coverPhotoId
├── createdBy
├── permissions

Recipes
├── id
├── title
├── ingredients
├── instructions
├── photos
├── submittedBy
├── category
├── origin

LicenseCodes
├── id
├── code
├── assignedName
├── assignedRelationship
├── preloadedBirthDate
├── preloadedLanguage
├── aiContext
├── isUsed
├── usedBy
├── createdAt
├── expiresAt
```

---

# SECURITY REQUIREMENTS

## Authentication:
- Secure password hashing (bcrypt)
- JWT tokens with expiration
- Refresh token rotation
- Optional 2FA (SMS or authenticator app)

## Data Privacy:
- End-to-end encryption for messages (E2EE)
- Encrypted file storage
- GDPR compliance ready
- Data export option
- Account deletion with full data removal

## Access Control:
- License code validation
- Role-based permissions (Admin, Member)
- Invite-only access
- Session management
- Device tracking

## Infrastructure:
- HTTPS everywhere
- DDoS protection
- Regular security audits
- Automated backups
- Disaster recovery plan

---

# USER ROLES & PERMISSIONS

| Role | Permissions |
|------|-------------|
| **Super Admin** | Full access, generate license codes, manage all users, delete anything |
| **Admin** | Generate codes, edit family tree, send urgent blasts, moderate content |
| **Member** | Standard access to all features, can add photos/recipes, send general blasts |
| **Child** | Limited access, no location sharing, parental controls |

---

# DEPLOYMENT REQUIREMENTS

## Domain Configuration (GoDaddy - eliteal.info):
- Point A record to hosting IP
- Configure SSL certificate
- Set up subdomains:
  - app.eliteal.info (main app)
  - api.eliteal.info (backend API)
  - admin.eliteal.info (admin panel)

## Environment Variables Required:
```
DATABASE_URL=
REDIS_URL=
JWT_SECRET=
OPENAI_API_KEY= (or ANTHROPIC_API_KEY)
GOOGLE_MAPS_API_KEY=
TWILIO_ACCOUNT_SID=
TWILIO_AUTH_TOKEN=
GOOGLE_TRANSLATE_API_KEY=
AWS_ACCESS_KEY=
AWS_SECRET_KEY=
AWS_S3_BUCKET=
FCM_SERVER_KEY=
```

---

# MVP PHASES

## Phase 1: Core (Weeks 1-4)
- [ ] License code system + signup flow
- [ ] User authentication
- [ ] Basic family chat (text only)
- [ ] User profiles
- [ ] Basic family tree (view only)

## Phase 2: Communication (Weeks 5-8)
- [ ] Voice messages
- [ ] Voice calls (1-on-1)
- [ ] Video calls (1-on-1)
- [ ] Group chats
- [ ] Notice Blast system

## Phase 3: Heritage (Weeks 9-12)
- [ ] Interactive family tree (full CRUD)
- [ ] Memory Vault (photo upload + albums)
- [ ] Memorial Pages
- [ ] Family Recipes
- [ ] "On This Day" feature

## Phase 4: Connection (Weeks 13-16)
- [ ] Live Location Map
- [ ] Birthday Reminders + Calendar
- [ ] Prayer/Support Requests
- [ ] Shared Photo Albums
- [ ] Voice Recorder + Lists

## Phase 5: Premium (Weeks 17-20)
- [ ] Real-time call translator
- [ ] AI Family Assistant (Kino)
- [ ] Rugby team themes
- [ ] Rugby news feed
- [ ] Group video calls

## Phase 6: Polish (Weeks 21-24)
- [ ] Performance optimization
- [ ] Security audit
- [ ] App store submission (iOS + Android)
- [ ] Admin dashboard refinement
- [ ] Beta testing with real family

---

# SUCCESS METRICS

| Metric | Target |
|--------|--------|
| Daily Active Users | 80% of registered family |
| Messages per day | 50+ family-wide |
| Photo uploads per month | 100+ |
| Video call minutes per week | 60+ |
| App crash rate | <1% |
| Message delivery success | 99.9% |
| User satisfaction | 4.5+ stars |

---

# DELIVERABLES EXPECTED

1. **Source Code Repository** (GitHub/GitLab)
   - Clean, documented code
   - README with setup instructions
   - Environment variable templates

2. **Web Application**
   - Responsive design
   - Works on desktop + tablet + mobile browsers

3. **Mobile Applications**
   - iOS app (App Store ready)
   - Android app (Play Store ready)

4. **Admin Dashboard**
   - License code management
   - User management
   - Family tree editor
   - Content moderation
   - Analytics

5. **API Documentation**
   - Swagger/OpenAPI spec
   - Authentication flow
   - All endpoints documented

6. **Database**
   - Schema migrations
   - Seed data scripts
   - Backup procedures

7. **Deployment**
   - CI/CD pipeline
   - Staging environment
   - Production environment
   - SSL configured
   - Domain connected

---

# ACCEPTANCE CRITERIA

The build is considered complete when:

- [ ] New user can enter license code and complete signup
- [ ] User sees personalized welcome with AI knowing their name/relationships
- [ ] User can send and receive text messages
- [ ] User can make voice calls
- [ ] User can make video calls
- [ ] User can view and navigate family tree
- [ ] User can see all family members on live map
- [ ] User receives birthday notifications
- [ ] User can send and receive Notice Blasts
- [ ] User can upload and view photos in Memory Vault
- [ ] User can view Memorial Pages for deceased members
- [ ] User can add and view family recipes
- [ ] User sees "On This Day" memories
- [ ] User can create prayer/support requests
- [ ] User can contribute to shared albums
- [ ] User can use voice recorder for notes/lists
- [ ] Real-time translator works during calls
- [ ] User can select rugby team and see themed UI
- [ ] User receives news updates for selected rugby team
- [ ] App works on iOS, Android, and web
- [ ] Admin can generate and manage license codes
- [ ] All data is secure and encrypted

---

# CONTACT

**Project Owner:** Bill Asmar  
**Email:** bill@oneillcontractors.com  
**Phone:** (708) 920-8904  

---

*This document is confidential and intended for development team evaluation purposes.*

**Document Version:** 1.0  
**Created:** January 2025  
**Product:** Kinora  
**Tagline:** "Your kin. Always close."
