using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.Tilemaps;
using DG.Tweening;

[RequireComponent(typeof(Camera))]
public class PostProcessing : MonoBehaviour
{
    public Material material;
    public Slider tempSlider;
    public Button[] buttons = new Button[3];
    public Tilemap[] tileMaps = new Tilemap[3];
    public SpriteRenderer[] backgroundSprites = new SpriteRenderer[3];

    private void Start()
    {
        material.SetFloat("_TemperatureRange", tempSlider.value);
        buttons[0].onClick.AddListener(() => { ChangeWeather(new int[] { 0, 1, 0, 0 }); });
        buttons[1].onClick.AddListener(() => { ChangeWeather(new int[] { 1, 0, 1, 0 }); });
        buttons[2].onClick.AddListener(() => { ChangeWeather(new int[] { -1, 0, 0, 1 }); });
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source, destination, material);
    }

    public void SliderChanged()
    {
        material.SetFloat("_TemperatureRange", tempSlider.value);
    }

    public void ChangeWeather(int[] parameters)
    {
        if (DOTween.TotalPlayingTweens() > 0) DOTween.KillAll();

        DOTween.To(() => tempSlider.value, x => tempSlider.value = x, parameters[0], 1);

        DOTween.To(() => tileMaps[0].color, x => tileMaps[0].color = x, new Color(1, 1, 1, parameters[1]), 1);
        DOTween.To(() => tileMaps[1].color, x => tileMaps[1].color = x, new Color(1, 1, 1, parameters[2]), 1);
        DOTween.To(() => tileMaps[2].color, x => tileMaps[2].color = x, new Color(1, 1, 1, parameters[3]), 1);

        backgroundSprites[0].DOFade(parameters[1], 1);
        backgroundSprites[1].DOFade(parameters[2], 1);
        backgroundSprites[2].DOFade(parameters[3], 1);
    }

    private void OnApplicationQuit()
    {
        buttons[0].onClick.RemoveAllListeners();
        buttons[1].onClick.RemoveAllListeners();
        buttons[2].onClick.RemoveAllListeners();
    }
}
