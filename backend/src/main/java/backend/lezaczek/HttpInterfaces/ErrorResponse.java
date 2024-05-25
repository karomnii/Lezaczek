package backend.lezaczek.HttpInterfaces;

import lombok.Getter;
import lombok.Setter;

public class ErrorResponse {
    @Getter @Setter String error;
    public ErrorResponse(String errorReason){
        this.error = errorReason;
    }
}
