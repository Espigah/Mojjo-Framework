package de.mojjoLib.services 
{
	public class EmailValidator{

        public function EmailValidator() {
            throw new Error("The EmailValidator class is not intended to be instantiated.");
        }
        
        // permissive, will allow quite a few non matching email addresses
        public static const EMAIL_REGEX : RegExp = /^[A-Z0-9._%+-]+@(?:[A-Z0-9-]+\.)+[A-Z]{2,4}$/i;

        /** Checks if the given string is a valid email address.
        *  @param email The email address as a String
        *  @return True if the given string is a valid email address, false otherwise.
        */
        public static function isValidEmail(email : String) : Boolean{
            return Boolean(email.match(EMAIL_REGEX));
        }
        
        /* Splits a string with the separator character, strips white characters and checks if all of them are valid
        */
        public static function isValidEmailList(emailList : String, separator : String = ",") : Boolean{
            var addresses : Array = emailList.split(separator);
            for each (var email : String in addresses){
                if (!isValidEmail(email.replace(/\s/, "")))return false;
            }
            return true;
        }
        
        public static function validate(email : String, errorClass : Class = null, errorMessage : String = "Invalid e-mail address.") : void{
            if (isValidEmail(email) )return;
            errorClass = errorClass || Error;
            throw new errorClass(errorMessage)
        }
    }

}