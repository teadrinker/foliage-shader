using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//[ExecuteInEditMode]
public class AutoRotate : MonoBehaviour
{
    // Start is called before the first frame update
    public float speed = 1f;
    // Update is called once per frame
    void Update()
    {
        var rot = transform.localEulerAngles;
        rot.y += Time.deltaTime * speed;
        transform.localEulerAngles = rot;
    }
}
