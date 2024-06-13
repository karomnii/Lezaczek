package backend.lezaczek.Controllers;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import backend.lezaczek.HttpInterfaces.ErrorResponse;
import backend.lezaczek.HttpInterfaces.Response;
import backend.lezaczek.Model.User;
import backend.lezaczek.Services.UserService;

import java.util.List;
import java.util.Optional;
import backend.lezaczek.Helpers.JwtTokenHelper;

@RestController
@RequestMapping("/user")
public class UserController {
    @Autowired
    JwtTokenHelper jwtTokenHelper;

    @Autowired
    UserService userService;

    @Autowired
    User currentUser;

    @PostMapping(path = "/delete", consumes ="application/json", produces = "application/json")
    public ResponseEntity<?> postMethodName(@RequestBody String entity) {
        Long userId = currentUser.getCurrentUser().getUserId();
        try {
            userService.deleteUser(userId);
        } catch (IllegalArgumentException e){
            return ResponseEntity.badRequest().body(new ErrorResponse("Cannot delete account"));
        }
        return ResponseEntity.ok(new Response("Account deleted"));
    }

    @GetMapping(path = "isAdmin")
    public ResponseEntity<?> getIsAdmin(HttpServletRequest request) throws Throwable {
        Long userId = jwtTokenHelper.extractUserId(request);
        Optional<User> userOptional = userService.findById(userId);
        if(userOptional.isPresent()){
            User user = userOptional.get();
            return ResponseEntity.ok(List.of(user.getIsAdmin()));
        }
        return ResponseEntity.badRequest().body(new ErrorResponse("Cannot reach data"));
    }
}
