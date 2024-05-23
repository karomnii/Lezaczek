package backend.lezaczek.Services;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Service;

import backend.lezaczek.Interfaces.UsersRepository;
import backend.lezaczek.Model.User;

@Service
public class UserService {
    @Autowired
    private UsersRepository usersRepository;
    @Query(value = "SELECT * FROM Users", nativeQuery = true)
    public List<User> getAllUsers() {
        return usersRepository.findAll();
    }
    public User saveUser(User user) {
        return usersRepository.save(user);
    }
}
