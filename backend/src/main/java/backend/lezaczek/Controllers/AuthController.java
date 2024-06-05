package backend.lezaczek.Controllers;

import java.lang.reflect.Field;
import java.util.Optional;

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

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequest LoginRequest, HttpServletRequest request,
            HttpServletResponse response) throws Exception {
        response.setContentType("application/json");
        User user;

        try {
            user = userService.findByEmail(LoginRequest.getEmail());
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new ErrorResponse("Invalid password or user not found"));
        }

        Boolean isSuccessfulLogin = authService.authenticate(user, LoginRequest.getPassword());
        if (!isSuccessfulLogin) {
            return ResponseEntity.badRequest().body(new ErrorResponse("Invalid password or user not found"));
        }
        AuthResponse authResponse = authService.setCookies(user, response);
        return ResponseEntity.ok(authResponse.toJsonString());
    }

    @GetMapping("/refresh")
    public ResponseEntity<?> refresh(Request<String, String> requestBody, HttpServletRequest request,
            HttpServletResponse response) throws Exception {
        String token = sessionHandler.getToken(request, "refreshToken");
        if (!sessionHandler.isValidToken(token, response)) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED.value())
                    .body(new ErrorResponse("Invalid authorization token").toJsonString());
        }
        Long userId = jwtTokenHelper.extractUserId(token);
        Optional<User> user = userService.findById(userId);
        if (user.isEmpty()) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body(new ErrorResponse("No user matches given token").toJsonString());
        }
        try {
            String accessToken = authService.refreshCookies(user.get(), response);
            return ResponseEntity.ok(new AuthResponse(accessToken).toJsonString());
        } catch (Throwable s) {
            return ResponseEntity.internalServerError().build();
        }
    }

    @PutMapping("/register")
    public ResponseEntity<?> register(@RequestBody RegisterRequest registerRequest, HttpServletRequest request,
            HttpServletResponse response) throws Exception {
        response.setContentType("application/json");
        try {
            for (Field field : registerRequest.getClass().getDeclaredFields()) {
                field.setAccessible(true);
                if (field.get(registerRequest) == null || field.get(registerRequest).toString().isEmpty()) {
                    return ResponseEntity.badRequest()
                            .body(new ErrorResponse("Missing required parameter: " + field.getName()));
                }
            }
            if (userService.findByEmail(registerRequest.getEmail()) != null) {
                return ResponseEntity.badRequest().body(new ErrorResponse("User with this email already exists"));
            }
            ;
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body(new ErrorResponse("Something went wrong"));
        }
        User user = new User(registerRequest);
        userService.saveUser(user);
        return ResponseEntity.ok(new Response("ok"));
    }

}