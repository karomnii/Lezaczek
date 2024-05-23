package backend.lezaczek.Services;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Service;

import backend.lezaczek.Model.User;
import backend.lezaczek.Repositories.UsersRepository;

@Service
public class UserService {
    @Autowired
    private UsersRepository usersRepository;
    public List<User> getAllUsers() {
        return usersRepository.findAll();
    }
    public User saveUser(User user) {
        return usersRepository.save(user);
    }
    public User findByEmail(String email) {
        return usersRepository.findByEmail(email);
    }
   
}
