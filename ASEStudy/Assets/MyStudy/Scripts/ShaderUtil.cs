using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;

public class ShaderUtil : MonoBehaviour {
    private string SvaePath {
        get {
            return Application.streamingAssetsPath + "/tmp.png"; 
        }
    }
    public Texture texture;

    void Start () {
		
	}

	void Update () {
        if (Input.GetKeyUp(KeyCode.S)) {
            MirrorTextureAndSave(texture, SvaePath);
        }
	}

    private void MirrorTextureAndSave(Texture texture, string path) {
        RenderTexture rt;
        if (texture != null) {
            rt = RenderTexture.GetTemporary(texture.width, texture.height, 0, RenderTextureFormat.ARGB32);
        } else {
            rt = RenderTexture.GetTemporary(512, 512, 0, RenderTextureFormat.ARGB32);
        }
        
        Material material = new Material(Shader.Find("Custom/NoiseTest"));

        Graphics.Blit(texture, rt, material);

        RenderTexture prev = RenderTexture.active;
        RenderTexture.active = rt;
        Texture2D png = new Texture2D(rt.width, rt.height, TextureFormat.ARGB32, false);
        png.ReadPixels(new Rect(0, 0, rt.width, rt.height), 0, 0);
        File.WriteAllBytes(path, png.EncodeToJPG());
        Texture2D.DestroyImmediate(png);
        png = null;
        RenderTexture.active = prev;
        RenderTexture.ReleaseTemporary(rt);

        Debug.Log("完成截图");
    }
}
