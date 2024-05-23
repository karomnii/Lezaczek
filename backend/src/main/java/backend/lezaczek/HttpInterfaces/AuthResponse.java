package backend.lezaczek.HttpInterfaces;

import java.io.IOException;

import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpServletResponseWrapper;
import lombok.Getter;
import lombok.Setter;

public class AuthResponse {
    @Getter @Setter private String accessToken;
    public AuthResponse(String accessToken) {
        this.accessToken = accessToken;
    }

}