package backend.lezaczek.Controllers;

import java.lang.reflect.Field;
import java.util.Optional;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import backend.lezaczek.Helpers.JwtTokenHelper;
import backend.lezaczek.HttpInterfaces.AuthResponse;
import backend.lezaczek.HttpInterfaces.ErrorResponse;
import backend.lezaczek.HttpInterfaces.LoginRequest;
import backend.lezaczek.HttpInterfaces.RegisterRequest;
import backend.lezaczek.HttpInterfaces.Request;
import backend.lezaczek.HttpInterfaces.Response;
import backend.lezaczek.Interceptors.SessionHandler;
import backend.lezaczek.Model.User;
import backend.lezaczek.Services.AuthService;
import backend.lezaczek.Services.UserService;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.springframework.web.bind.annotation.GetMapping;
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
    @Autowired
    SessionHandler sessionHandler;
    private static Pattern emailPattern = Pattern.compile("^[a-zA-Z0-9_!#$%&'*+/=?`{|}~^.-]+@[a-zA-Z0-9.-]+$", Pattern.CASE_INSENSITIVE);
    private static Pattern passwordPattern = Pattern.compile("^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=\\S+$).{8,20}$", Pattern.CASE_INSENSITIVE);
    private static final long ACCESS_TOKEN_EXPIRATION = 1000 * 60 * 15; // 15 minutes
    private static final long REFRESH_TOKEN_EXPIRATION = 1000 * 60 * 60 * 24 * 7; // 7 days

    @PostMapping(value = "/login", produces = {"application/json"}, consumes = {"application/json"})
    public ResponseEntity<?> login(@RequestBody LoginRequest loginRequest, HttpServletRequest request, HttpServletResponse response) throws Exception {
        response.setContentType("application/json");
        Matcher emailMatcher = emailPattern.matcher(loginRequest.getEmail());
        if (!emailMatcher.matches()){
            return ResponseEntity.ok(new ErrorResponse("Invalid email"));
        }
        User user;
        try {
            user = userService.findByEmail(loginRequest.getEmail());
        }
        catch (Exception e) {
            return ResponseEntity.ok(new ErrorResponse("Invalid password or user not found"));
        }

        Boolean isSuccessfulLogin = authService.authenticate(user, loginRequest.getPassword());
        if (!isSuccessfulLogin) {
            return ResponseEntity.ok(new ErrorResponse("Invalid password or user not found"));
        }
        String accessToken = jwtTokenHelper.generateToken(user.getUserId(), ACCESS_TOKEN_EXPIRATION);
        String refreshToken = jwtTokenHelper.generateToken(user.getUserId(), REFRESH_TOKEN_EXPIRATION);
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
        AuthResponse authResponse = new AuthResponse(accessToken, refreshToken, user);
        return ResponseEntity.ok(authResponse.toJsonString());
    }
    @GetMapping(value = "/refresh", produces = {"application/json"})
    public ResponseEntity<?> refresh(Request<String, String> requestBody, HttpServletRequest request, HttpServletResponse response) throws Exception {
        String token = sessionHandler.getToken(request, "refreshToken");
        if(!sessionHandler.isValidToken(token, response)){
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED.value()).body(new ErrorResponse("Invalid authorization token").toJsonString());
        }
        Long userId = jwtTokenHelper.extractUserId(token);
        Optional<User> user = userService.findById(userId);
        if(user.isEmpty()){
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(new ErrorResponse("No user matches given token").toJsonString());
        }
        try {
            String accessToken = jwtTokenHelper.generateToken(userId, ACCESS_TOKEN_EXPIRATION);
            Cookie accessTokenCookie = new Cookie("accessToken", accessToken);
            accessTokenCookie.setHttpOnly(true);
            accessTokenCookie.setSecure(true);
            accessTokenCookie.setPath("/");
            response.addCookie(accessTokenCookie);
            return ResponseEntity.ok(new AuthResponse(accessToken).toJsonString());
        } catch (Throwable s) {
            return ResponseEntity.internalServerError().build();
        }
    }
    @PutMapping(value = "/register", produces = {"application/json"}, consumes = {"application/json"})
    public ResponseEntity<?> register(@RequestBody RegisterRequest registerRequest, HttpServletResponse response) throws Exception {
        response.setContentType("application/json");
        try {
            for (Field field : registerRequest.getClass().getDeclaredFields()){
                field.setAccessible(true);
                if (field.get(registerRequest) == null || field.get(registerRequest).toString().isEmpty()){
                    return ResponseEntity.badRequest().body(new ErrorResponse("Missing required parameter: " + field.getName()));
                }
            }
            if(userService.findByEmail(registerRequest.getEmail()) != null) {
                return ResponseEntity.ok(new ErrorResponse("User with this email already exists"));
            };
        }
        catch (Exception e) {
            return ResponseEntity.internalServerError().body(new ErrorResponse("Something went wrong"));
        }
        Matcher matcher = passwordPattern.matcher(registerRequest.getPassword());
        if(!matcher.matches()){
            return ResponseEntity.ok(new ErrorResponse("Password should be 8-20 characters long, contain at least one small letter, one capital letter, one digit"));
        }
        User user = new User(registerRequest);
        userService.saveUser(user);
        return ResponseEntity.ok(new Response("ok"));
    }

}