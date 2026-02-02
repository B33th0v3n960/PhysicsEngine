static class Vector {
  public static float dotProduct(float vector1[], float vector2[]) {
    if (vector1 != null && vector2 != null && vector1.length == vector2.length) {
      float result = 0.0;
      for (int component = 0; component < vector1.length; component++) {
        result += vector1[component] * vector2[component];
      }
      return result;
    }
    return 0.0;
  }
  
  public static float magnitude(float vector[]) {
    if (vector != null){
      float magnitudeSquared = 0;
      for (float component: vector) {
        magnitudeSquared +=  component * component;
      }
      return sqrt(magnitudeSquared);
    }
    return 0.0;
  }
  
  public static float[] addition(float vector1[], float vector2[]) {
    if (vector1 != null && vector2 != null && vector1.length == vector2.length) {
      float result[] = new float[vector1.length];
      for (int component = 0; component < vector1.length; component++) {
        result[component] = vector1[component] + vector2[component];
      }

      return result;
    }
    return null;
  }

  public static float[] scalarMul(float scalar, float vector[]){
    if (vector != null){
      float result[] = new float[vector.length];
      for (int component = 0; component < vector.length; component++) {
        result[component] = vector[component] * scalar;
      }
      return result;
    }
    return null;
  }
  
  public static float[] projection(float[] projVector, float[] inputVector){
     if(projVector != null && inputVector != null && projVector.length == inputVector.length) {
       float scalarCoefficient = dotProduct(projVector, inputVector) * (1 / pow(magnitude(projVector), 2));
       return scalarMul(scalarCoefficient, projVector);
     }
     return null;
  }
}

static class Matrix {
  public static float[] multiply(float matrix[][], float vector[]) {
    if (matrix != null && vector != null && matrix[0].length == vector.length){
      float result[] = new float[matrix.length];
      for (int row = 0; row < matrix.length; row++) {
        result[row] = Vector.dotProduct(matrix[row], vector);
      }
      return result;
    }
    return null;
  }

  public static float[][] rotationMatrix(float x, float y, float angle){
    return new float[][] {
      {cos(angle), -sin(angle), x},
      {sin(angle),  cos(angle), y},
      {         0,           0, 1}
    };
  }
}
