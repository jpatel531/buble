#Bublé

This is me trying to re-implement Sinatra as a way to learn more about 'what's under the hood'.

##How To Run

Clone this repo.

    $ ruby app.rb

    Michael Bublé is recording another Christmas album on port 5678...

Open up your browser and go onto localhost:5678, and you should find the words: "Hello Me!".

If you send a POST request to `/test`, you should get `{success:200}`

##To Do

* Implement params
* Implement appropriate error handlers
* Implement more HTTP methods
* Reimplement request loop with GServer
* Make port and directories configurable
* And many others