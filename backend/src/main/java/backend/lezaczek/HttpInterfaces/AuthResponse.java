package backend.lezaczek.HttpInterfaces;

import java.util.Map;

import lombok.Getter;
import lombok.Setter;

public class AuthResponse extends Response {
    @Getter @Setter private String accessToken;
    public AuthResponse(String accessToken, String refreshToken) {
        super(Map.of("accessToken", accessToken, "refreshToken", refreshToken));
    }

}