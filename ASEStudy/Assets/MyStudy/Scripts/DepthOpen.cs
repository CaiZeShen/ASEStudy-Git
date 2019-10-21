// ****************************************************************
// 作	 者：#SMARTDEVELOPERS#
// 创建时间：#CREATIONDATE#
// 备	 注：
// 修改内容：										修改者姓名：
// ****************************************************************

using UnityEngine;

/// <summary>
/// 
/// </summary>
[RequireComponent(typeof(Camera))]
public class DepthOpen : MonoBehaviour {

#if UNITY_EDITOR
    void OnDrawGizmos() {
        Set();
    }
#endif
    void Start() {
        Set();
    }
    void Set() {
        if (GetComponent<Camera>().depthTextureMode == DepthTextureMode.None)
            GetComponent<Camera>().depthTextureMode = DepthTextureMode.Depth;
    }

}
