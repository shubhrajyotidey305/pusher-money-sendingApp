# Pusher Money Sending and Receiving App
Created by: Ansh Goyal & Shubhrajyoti Dey

## Set up Guide
- First turn on the server by following that guide.
- Now, go to home.dart file. Under 'pusher.init' place your own api key and cluster. You can get them by creating an account in 'pusher.com'.

## Resources
- Pusher is a hosted API service which makes adding real-time data and functionality to web and mobile applications seamless . Pusher works as a real-time communication layer between the server and the client. It maintains persistent connections at the client using WebSockets, as and when new data is added to your server.
- [Pusher Channel Flutter Docs](https://pub.dev/packages/pusher_channels_flutter)
- [Pusher Official Docs](https://pusher.com/docs/)


## Code Base in Short
- A login Screen is created first. User need to type his username. It will then rerouted to the Wallet Home Screen.
- The Wallet Tab will show the total amount of money that is received. And underneath of that there is a "Send" button. Which will send the amount that has been written in the Space available in leftwards.
- Below is a list of 'Past Transaction' which will be updated with transactions.

## Packages
- http 
- Pusher Channel

## Explanation
- The transaction is happening using pusher channels.
- Pusher has three types of channels i.e Public, Private and Presence Channel.
- For triggering client side event we used private (presence channel can be used too) Channel.
- For using a private channel a authentication has to be done.
- We built a node Js server, where this app will send a 'POST' request to authenticate. 'Socket Id' and 'Channel name' are the parameters for authentication. Then server will revert back a response with 'auth' code.
- onAuthorizer function is used for this purpose.
- After that this app subscribes to a 'private' channel. The channel name should be prefixed with 'private-'.
- We have written a 'trigger' method where client side events get triggered. Basically the 'rupee', 'sender', 'time' is sent to another user through pusher private channel.
- From the other user end, upon receiving the data. We showed the 'rupee', 'sender', 'time' in appropriate places.



