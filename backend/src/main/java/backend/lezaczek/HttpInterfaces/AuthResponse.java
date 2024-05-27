package backend.lezaczek.HttpInterfaces;

import java.util.Map;


public class AuthResponse extends ComplexResponse {

    public AuthResponse(String accessToken, String refreshToken) {
        super(Map.of("accessToken", accessToken, "refreshToken", refreshToken));
    }
    public AuthResponse(String accessToken) {
        super(Map.of("accessToken", accessToken));
    }

}