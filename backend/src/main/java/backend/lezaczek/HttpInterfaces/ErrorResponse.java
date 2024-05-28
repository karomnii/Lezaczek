package backend.lezaczek.HttpInterfaces;

import lombok.Getter;

public class ErrorResponse extends Response {
    @Getter String errorReason;
    public ErrorResponse(String errorReason){
        super("error");
        this.errorReason = errorReason;
    }
    public String toJsonString(){
        return "{" + super.toString() + ",\"errorReason\":\""+this.errorReason+"\"}";
        
    }
}
