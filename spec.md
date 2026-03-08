# CivWorld

## Current State
CivWorld is a civic discussion platform built on Internet Computer (ICP) with React + TypeScript frontend and Motoko backend. Current features include:
- Post feed with text/image/video
- Polls with voting and results
- Communities (Groups & Pages)
- Video Reels feed
- My Constituency civic reporting
- CivPoints (CP) wallet system
- Internet Identity authentication
- Admin panel for moderation
- Bottom nav: Home, Reels, Discuss, Polls, Communities

## Requested Changes (Diff)

### Add
- **CivWorld Live** section: a new top-level page accessible from the bottom nav (replacing or adding to existing nav)
- **Live Session data model** in backend: id, title, topic, leader (Principal), constituency, scheduledTime, startedAt, endedAt, status (scheduled/live/ended), viewerCount, streamUrl (optional placeholder)
- **Live Comment data model**: id, sessionId, authorId, content, timestamp, likes (Set<Principal>), isModerated, moderationReason, parentCommentId (for questions)
- **Live Reaction data model**: sessionId, authorId, reactionType (fire/heart/clap/wave/flag), timestamp
- **Question Upvote**: upvotes field (Set<Principal>) on LiveComment when parentCommentId is null (top-level = question)
- **Schedule Notification**: when leader schedules a session, notify all users in same constituency
- **Leader Archive**: query to list all ended sessions with metadata
- Backend functions:
  - `createLiveSession(title, topic, constituency, scheduledTime)` — verified leaders only
  - `startLiveSession(sessionId)` — leader only
  - `endLiveSession(sessionId)` — leader only
  - `getLiveSessions(status)` — public query
  - `getLiveSession(sessionId)` — public query
  - `addLiveComment(sessionId, content, parentCommentId?)` — authenticated users
  - `moderateLiveComment(sessionId, commentId, reason)` — leader/admin only
  - `upvoteQuestion(sessionId, commentId)` — authenticated users
  - `addLiveReaction(sessionId, reactionType)` — authenticated users
  - `getSessionComments(sessionId)` — public query
  - `getSessionReactions(sessionId)` — public query
  - `getLeaderArchive()` — public query (ended sessions only)
  - `getScheduledSessions()` — public query

- **Frontend pages**:
  - `CivWorldLivePage` — main listing page with tabs: Live Now / Scheduled / Archive
  - `LiveSessionPage` — individual live session view with video placeholder, live comments, question upvoting, reactions
  - `CreateLiveSessionModal` — modal for leaders to schedule/start a live session

- **Frontend components**:
  - `LiveSessionCard` — card for listing page (shows status badge, title, leader, topic, constituency, viewer count)
  - `LiveCommentSection` — real-time comment list with upvoting on questions, moderation, replies
  - `LiveReactionBar` — floating emoji reaction bar (fire, heart, clap, wave)
  - `AIModerationBadge` — visual indicator when a comment is AI-moderated/hidden
  - `LeaderArchiveCard` — card for archived sessions with replay placeholder

### Modify
- `BottomNav` — add "Live" nav item with a live/broadcast icon
- `App.tsx` — add routes: `/live`, `/live/$sessionId`, `/live/create`
- `backend/main.mo` — add live session types and functions

### Remove
- Nothing removed

## Implementation Plan
1. Write spec.md (this file)
2. Generate Motoko backend with live session, live comment, live reaction, upvoting, notification hooks
3. Frontend: create CivWorldLivePage (tabs: Live Now / Scheduled / Archive), LiveSessionPage, CreateLiveSessionModal, LiveSessionCard, LiveCommentSection, LiveReactionBar
4. Add `/live` route and nav item
5. AI moderation: client-side keyword filter + flag system (no external API needed — pattern-based heuristic)
6. Auto-refresh comments/reactions every 8 seconds to simulate near-real-time
7. Notifications: store in existing notifications map when session is scheduled
8. Deploy
