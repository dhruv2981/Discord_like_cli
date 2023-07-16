class ValueException implements Exception {
    
    String _message = "";
  
    ValueException([String message = 'Invalid value']) {
      this._message = message;
    }
  
    @override
    String toString() {
      return _message;
    }
  }

  void validatePwd(String pwd, String conf_pwd){
    if(pwd != conf_pwd){
        throw new ValueException("Password dont match");
    }
  }