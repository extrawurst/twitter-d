module twitter.twitter;

import twitter.api;
import twitter.twitterbase;

import std.conv : to;
import vibe.data.json : Json;
import vibe.http.common : HTTPMethod;

///
class Twitter : TwitterBase, TwitterAPI
{
    ///
    this(TwitterCredentials credentials)
    {
        super(credentials);
    }

    ///
    FollowersList followers(string screen_name, long cursor = -1,
            bool skip_status = true, bool include_user_entities = false)
    {
        static immutable METHOD_URL = "/1.1/followers/list.json";

        string[string] params;
        params["screen_name"] = screen_name;
        params["cursor"] = cursor.to!string;
        params["skip_status"] = skip_status.to!string;
        params["include_user_entities"] = include_user_entities.to!string;

        return this.request!(FollowersList)(METHOD_URL, HTTPMethod.GET, params);
    }

    ///
    Status status(string status)
    {
        static immutable METHOD_URL = "/1.1/statuses/update.json";

        string[string] params;
        params["status"] = status;

        return this.request!(Status)(METHOD_URL, HTTPMethod.POST, params);
    }

    ///
    Status statusShow(long id)
    {
        static immutable METHOD_URL = "/1.1/statuses/show.json";

        string[string] params;
        params["id"] = id.to!string;

        return this.request!(Status)(METHOD_URL, HTTPMethod.GET, params);
    }
}
