import Map "mo:core/Map";
import Nat "mo:core/Nat";
import List "mo:core/List";

module {
  type LiveSessionStatus = {
    #scheduled;
    #live;
    #ended;
  };

  type LiveSession = {
    id : Nat;
    title : Text;
    topic : Text;
    leader : Principal;
    constituency : Text;
    scheduledTime : Int;
    startedAt : ?Int;
    endedAt : ?Int;
    status : LiveSessionStatus;
    viewerCount : Nat;
  };

  type LiveComment = {
    id : Nat;
    sessionId : Nat;
    authorId : Principal;
    content : Text;
    timestamp : Int;
    upvotes : [Principal];
    parentCommentId : ?Nat;
    isModerated : Bool;
    moderationReason : ?Text;
  };

  type LiveReactionType = {
    #fire;
    #heart;
    #clap;
    #wave;
  };

  type LiveReaction = {
    sessionId : Nat;
    authorId : Principal;
    reactionType : LiveReactionType;
    timestamp : Int;
  };

  // Persistent state additions for live sessions
  type LiveSessionState = {
    liveSessions : Map.Map<Nat, LiveSession>;
    liveSessionComments : Map.Map<Nat, List.List<LiveComment>>;
    liveSessionReactions : Map.Map<Nat, List.List<LiveReaction>>;
    liveSessionCounter : Nat;
    liveCommentCounter : Nat;
  };

  // Migration function to initialize live sessions state
  public func run(_ : {}) : LiveSessionState {
    {
      liveSessions = Map.empty<Nat, LiveSession>();
      liveSessionComments = Map.empty<Nat, List.List<LiveComment>>();
      liveSessionReactions = Map.empty<Nat, List.List<LiveReaction>>();
      liveSessionCounter = 0;
      liveCommentCounter = 0;
    };
  };
};
