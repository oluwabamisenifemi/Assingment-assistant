//this is an app that helps students record homework given to them
//it could serve as the backend for a website where data would be displayed and interacted with.

import Text "mo:base/Text";
import Time "mo:base/Time";
import Array "mo:base/Array";
import Result "mo:base/Result";
actor homeworkassist {
type Result<T,E> = Result.Result<T,E>;
//to store our user objects
type User = {
    username : Text;
    Password : Text;
};

//  define a type "homework"
    type Homework = {
        name : Text;
        course : Text;
        question : Text;
        dueDate : Int;
        completed : Bool;
    };
//arrays are very usefull as a data structure to store and organise data
  stable var users : [User] = [];
  var currentUser: ?User = null;
   stable var homeworks : [Homework] = [];

   // user registration
    public func registerUser(newUser : User) : async Result<Text,Text> {
        users := Array.append(users, [newUser]);
        return #ok("successful");
    };


//you can only perfom certain (adding new assignments)operations once you register
   //this function logs you in so you can perform operations
    public func loginUser(username : Text, password : Text) : async Result<Text,Text> {
        // Find the user by username
        let user = Array.filter<User>(users, func(u) { u.username == username });
        if(user.size() == 0){
          return #err("user does not exist");
        }
        else {
            if (user[0].Password == password) {
                    currentUser := ?user[0];
                    return #ok("logged in user");
                } else {
                    return #err(" Password doesn't match"); //
                }
        }

    };

//this  function displays all the homework recorded which are publicly visible
public func getHomework() : async [Homework]  {
        return homeworks;
  };

//the append function is used to push data into an array
//here we are writing a function to create a new homework
//only authorised users can create new homework
  public func addHomework(newHomework : Homework) : async Result<Text,Text> {
        let hasAuthenticated = await authenticateUser();
        if (not hasAuthenticated) {
            // Authentication failed, handle error or return unauthorized status
            return #err("you are not logged in");
        };
        homeworks := Array.append(homeworks, [newHomework]);
        return #ok("home work added successfully");
    };




//this gets all data and gets those that a past their due date for submission
public func getPastDueHomeworks() : async [Homework]  {
        let currentTime = Time.now();
        let pastDueHomeworks = Array.filter<Homework>(homeworks, func homework { homework.dueDate < currentTime});
        pastDueHomeworks;
    };


    public func logoutUser() : async Result<Text,Text> {
        currentUser := null; // Clear the current user
        return #ok("user logged out");
    };



     func authenticateUser(): async Bool{
      switch(currentUser){
        case(null){
          return false;
        };
        case(?currentUser){
          return true;
        }
      }
    };










};
