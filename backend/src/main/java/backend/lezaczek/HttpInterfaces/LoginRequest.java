package backend.lezaczek.HttpInterfaces;

import lombok.Getter;
import lombok.Setter;

public class LoginRequest extends Request<String, Object> {
    @Getter
    @Setter
    private String email;
    @Getter
    @Setter
    private String password;

    public LoginRequest() {
    };

    public LoginRequest(String email, String password) {
        this.email = email;
        this.password = password;
    }
}