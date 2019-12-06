import com.demo.controller.TestController;
import com.demo.service.PackageService;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.io.IOException;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:applicationContext.xml", "classpath:springmvc.xml"})
public class PackageTest {

    @Autowired
    TestController testController;
    @Autowired
    PackageService packageService;

    @Test
    public void packageTest(){
        //生成plist文件
        try {
            packageService.createPlist("http://10.55.53.5:8686","AVGO","com.avgo.cs","");
        }catch (IOException e){
            e.printStackTrace();
        }

    }
}
