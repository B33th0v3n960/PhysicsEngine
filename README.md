# Physic Engine

## Collision System
- Built with Separation Axis Theorem (SAT)
- Detects collision between
    - Rectangles to Rectangles
    - Circle to Circles
    - Rectangles to Circles
- Using visitors design pattern and double dispatch abstracted collision to:
```java
character.collidesWith(enemy);
```

## TODO:
- [ ] Using strategy design pattern create collision resolution
- [ ] Implement ridged body to physics engine
- [ ] Include dynamics, kinematics and static objects
