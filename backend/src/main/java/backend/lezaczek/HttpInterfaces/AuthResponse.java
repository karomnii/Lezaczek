package backend.lezaczek.HttpInterfaces;

import java.util.Map;

import backend.lezaczek.Model.User;


public class AuthResponse extends ComplexResponse {

    public AuthResponse(String accessToken, String refreshToken, User user) {
        super(Map.of("accessToken", accessToken, "refreshToken", refreshToken, "user", user));
    }
    public AuthResponse(String accessToken) {
        super(Map.of("accessToken", accessToken));
    }

}