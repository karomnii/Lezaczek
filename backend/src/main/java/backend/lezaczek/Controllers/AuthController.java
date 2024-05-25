package backend.lezaczek.Controllers;

import java.lang.reflect.Field;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import backend.lezaczek.Helpers.JwtTokenHelper;
import backend.lezaczek.HttpInterfaces.AuthResponse;
import backend.lezaczek.HttpInterfaces.ErrorResponse;
import backend.lezaczek.HttpInterfaces.LoginRequest;
import backend.lezaczek.HttpInterfaces.RegisterRequest;
import backend.lezaczek.HttpInterfaces.Response;
import backend.lezaczek.Model.User;
import backend.lezaczek.Services.AuthService;
import backend.lezaczek.Services.UserService;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.PutMapping;



@RestController
@RequestMapping("/auth")
public class AuthController {
    @Autowired
    private UserService userService;
    @Autowired
    private AuthService authService;
    @Autowired
    JwtTokenHelper jwtTokenHelper;

    private static final long ACCESS_TOKEN_EXPIRATION = 1000 * 60 * 15; // 15 minutes
    private static final long REFRESH_TOKEN_EXPIRATION = 1000 * 60 * 60 * 24 * 7; // 7 days
    
    @PostMapping(value = "/login", produces = {"application/json"}, consumes = {"application/json"})
    public ResponseEntity<?> login(@RequestBody LoginRequest LoginRequest, HttpServletRequest request, HttpServletResponse response) throws Exception {
        response.setContentType("application/json");
        //TODO: process POST request
        User user;

        try {
            user = userService.findByEmail(LoginRequest.getEmail());
        }
        catch (Exception e) {
            return ResponseEntity.ok(new ErrorResponse("Invalid password or user not found"));
        }

        Boolean isSuccessfulLogin = authService.authenticate(user, LoginRequest.getPassword());
        if (!isSuccessfulLogin) {
            return ResponseEntity.ok(new ErrorResponse("Invalid password or user not found"));
        }
        String accessToken = jwtTokenHelper.generateToken(String.valueOf(user.getUserId()), ACCESS_TOKEN_EXPIRATION);
        String refreshToken = jwtTokenHelper.generateToken(String.valueOf(user.getUserId()), REFRESH_TOKEN_EXPIRATION);
        Cookie accessTokenCookie = new Cookie("accessToken", accessToken);
        Cookie refreshTokenCookie = new Cookie("refreshToken", refreshToken);
        accessTokenCookie.setHttpOnly(true);
        accessTokenCookie.setSecure(true);
        accessTokenCookie.setPath("/");
        accessTokenCookie.setMaxAge((int) ACCESS_TOKEN_EXPIRATION / 1000);
        refreshTokenCookie.setHttpOnly(true);
        refreshTokenCookie.setSecure(true);
        refreshTokenCookie.setPath("/api/v1/auth/refresh");
        refreshTokenCookie.setMaxAge((int) REFRESH_TOKEN_EXPIRATION / 1000);
        response.addCookie(accessTokenCookie);
        response.addCookie(refreshTokenCookie);
        Response authResponse = new AuthResponse(accessToken, refreshToken);
        return ResponseEntity.ok(authResponse.toJsonString());
    }
    @PutMapping(value = "/register", produces = {"application/json"}, consumes = {"application/json"})
    public ResponseEntity<?> register(@RequestBody RegisterRequest registerRequest, HttpServletRequest request, HttpServletResponse response) throws Exception {
        //TODO: process PUT request
        response.setContentType("application/json");
        try {
            if(userService.findByEmail(registerRequest.getEmail()) != null) {
                return ResponseEntity.ok(new ErrorResponse("User with this email already exists"));
            };
        }
        catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
        for (Field field : registerRequest.getClass().getDeclaredFields()){
            field.setAccessible(true);
            if (field.get(registerRequest) == null){
                return ResponseEntity.badRequest().body(new ErrorResponse("Missing required parameter"));
            }
        }
        User user = new User(registerRequest);
        userService.saveUser(user);
        return ResponseEntity.ok(new Response(Map.of("ok", "ok")));
    }
    
}
