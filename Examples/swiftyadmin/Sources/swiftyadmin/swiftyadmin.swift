import ArgumentParser

@main
struct SwiftyAdmin: AsyncParsableCommand {
    static var configuration = CommandConfiguration(
        abstract:
            "An example command line utility to interact with and control a server using TootSDK.",
        version: "1.0.0",
        subcommands: [
            Login.self,
            ListDomainBlocks.self,
            BlockDomain.self,
            UnblockDomain.self,
            ListOauthApps.self,
            DeleteOauthApp.self,
            ListLists.self,
            ListCreate.self,
            ListDelete.self,
            ListRelationships.self,
            Follow.self,
            FollowByURI.self,
            Unfollow.self,
            GetPost.self,
            GetFlavour.self,
            RegisterAccount.self,
            GetFeaturedTags.self,
            GetTrendingTags.self,
            GetTrendingPosts.self,
            GetTrendingLinks.self,
            GetTag.self,
            FollowTag.self,
            UnfollowTag.self,
            ListAllNotifications.self,
            GetFollowers.self,
            GetPostContext.self,
            GetConversations.self,
            GetInstance.self,
            GetMarkers.self,
            UpdateMarkers.self,
            GetPendingFollowRequests.self,
            AcceptFollowRequest.self,
            RejectFollowRequest.self,
            GetPushSubscription.self,
            DeletePushSubscription.self,
            FollowAccount.self,
        ])
}
