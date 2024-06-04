package backend.lezaczek.Services;

import java.sql.Date;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
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
        user.setIsAdmin(0);
        user.setTimeCreated(new Date(System.currentTimeMillis()));
        System.out.println("Salt before save:" + user.getSalt());
        return usersRepository.save(user);
    }
    public User findByEmail(String email) {
        return usersRepository.findByEmail(email);
    }
    public Optional<User> findById(Long id){
        return usersRepository.findById(id);
    }
    public void deleteUser(Long id) throws IllegalArgumentException{
        usersRepository.deleteById(id);
    }
   
}