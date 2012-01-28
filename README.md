MPMediaItem DZCloud
====================
Recently Apple introduces iCloud and iTunes Match, which stores portions of a user's music library remotely. Unfortunately, the Apple APIs that allow developers access to the user's media library do not provide distinctions between local and remote content. A song or movie that exists only on iCloud appears as if it were on the device. An attempt to play back that song or movie will download it in the background if the user has not disabled that functionality (if they have, it just does not play).

This category provides a method for determining wether an MPMediaItem exists in the iPod library on the device or not. There are some caveats, so read through the source to familiarize yourself with those before using this in any kind of production system.
