let
  windowsPc = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDvqb4Nu8zH0y8XylZVXIUpgI/cBJ4SeQXKkw6t5dTbo antoine.bourgeois1996@gmail.com";
  windowsPcWsl = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC7ig2rTLNkn1U3Lwoq97KASoPWg96IeP4NMsgrJqMUL4l2lU+Rdne5vuhUIUwzTn1B3/tWJQy54dJuLMzFw+UpHDeHHEzDjFPqftXYAwzoQh7At3//iplGdv7bdy06BsyU3t8YGY+xRPB5VncuPjVlVvjluJjl0r4RLgOvCs2m1FxNlEKwLxccoAezb5ekTt+sot658tRJQ/wxMXXwWs7P1oIBvtaPyWn8dVyXwH3sZ024uLaUznj1BikfQEZ1s6gW8xSXwVIlfSVEzNrac0/Z4rxESVZY1w4ciOier2NO0x6kVEgw3cdVqLplBiGJGPuZEJbF34xvQplIh9U/mh3+5L4TWx9KoAysp6VAhmnjIpADm25qja7IOcqa4TOCChHPJ34Lx7TbVrBJcp5zOpeLrmJKhQ7gWwg6/3ULc8Zfg07cJlwkr2ufWKUM+q69cX6eqd4CH+G2oxdMoRI6wL8G5LQJrNFwwGL/VUpcIa0y5Jp3qLuudF5031s4tnvsVfc= antoine.bourgeois@DL68G14J3";
  evangelyne = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDmOu03fhRtKLgdABqiodg8qHHpefL2SwbxVCgljUPs3 root@evangelyne";
  tristepin = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHAOPowaaPgdYl2jXqWWLE87r/sbstxQhFkYOkz/oo52 root@tristepin";
  
  users = [ windowsPc windowsPcWsl ]; 
  systems = [ evangelyne tristepin ];
in
{
  "passwords/user.age".publicKeys = users ++ systems;
  "passwords/root.age".publicKeys = users ++ systems;
  "wireguards/evangelyne-pk.age".publicKeys = users ++ systems;
  "wireguards/tristepin-pk.age".publicKeys = users ++ systems;
}