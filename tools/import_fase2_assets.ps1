param(
    [Parameter(Mandatory = $false)]
    [string]$SourceDir = "E:\Usuario\Downloads"
)

$ErrorActionPreference = "Stop"
$projectRoot = Split-Path -Parent $PSScriptRoot

function New-GmSprite {
    param(
        [string]$Name,
        [string[]]$Files,
        [int]$Width,
        [int]$Height,
        [double]$Fps = 8,
        [int]$Origin = 4,
        [int]$XOrigin = 48,
        [int]$YOrigin = 48,
        [int]$BboxLeft = 0,
        [int]$BboxTop = 0,
        [int]$BboxRight = 95,
        [int]$BboxBottom = 95
    )

    $spriteDir = Join-Path $projectRoot "sprites\$Name"
    New-Item -ItemType Directory -Path $spriteDir -Force | Out-Null
    $layerId = [guid]::NewGuid().ToString()
    $frames = @()
    $keys = @()

    for ($i = 0; $i -lt $Files.Count; $i++) {
        $frameId = [guid]::NewGuid().ToString()
        $keyId = [guid]::NewGuid().ToString()
        $layerDir = Join-Path $spriteDir "layers\$frameId"
        New-Item -ItemType Directory -Path $layerDir -Force | Out-Null
        $sourcePath = Join-Path $SourceDir $Files[$i]
        $framePath = Join-Path $spriteDir "$frameId.png"
        $layerPath = Join-Path $layerDir "$layerId.png"
        if ([IO.Path]::GetExtension($sourcePath) -match '^\.(jpg|jpeg)$') {
            Add-Type -AssemblyName System.Drawing
            $bitmap = [Drawing.Image]::FromFile($sourcePath)
            try {
                $bitmap.Save($framePath, [Drawing.Imaging.ImageFormat]::Png)
                $bitmap.Save($layerPath, [Drawing.Imaging.ImageFormat]::Png)
            } finally {
                $bitmap.Dispose()
            }
        } else {
            Copy-Item -LiteralPath $sourcePath -Destination $framePath -Force
            Copy-Item -LiteralPath $sourcePath -Destination $layerPath -Force
        }
        $frames += '    {"$GMSpriteFrame":"v1","%Name":"' + $frameId + '","name":"' + $frameId + '","resourceType":"GMSpriteFrame","resourceVersion":"2.0",},'
        $keys += '            {"$Keyframe<SpriteFrameKeyframe>":"","Channels":{"0":{"$SpriteFrameKeyframe":"","Id":{"name":"' + $frameId + '","path":"sprites/' + $Name + '/' + $Name + '.yy",},"resourceType":"SpriteFrameKeyframe","resourceVersion":"2.0",},},"Disabled":false,"id":"' + $keyId + '","IsCreationKey":false,"Key":' + $i + '.0,"Length":1.0,"resourceType":"Keyframe<SpriteFrameKeyframe>","resourceVersion":"2.0","Stretch":false,},'
    }

    $yy = @"
{
  `"`$GMSprite`":`"v2`",
  `"%Name`":`"$Name`",
  `"bboxMode`":0,
  `"bbox_bottom`":$BboxBottom,
  `"bbox_left`":$BboxLeft,
  `"bbox_right`":$BboxRight,
  `"bbox_top`":$BboxTop,
  `"collisionKind`":1,
  `"collisionTolerance`":0,
  `"DynamicTexturePage`":false,
  `"edgeFiltering`":false,
  `"For3D`":false,
  `"frames`":[
$($frames -join "`n")
  ],
  `"gridX`":0,
  `"gridY`":0,
  `"height`":$Height,
  `"HTile`":false,
  `"layers`":[
    {`"`$GMImageLayer`":`"`",`"%Name`":`"$layerId`",`"blendMode`":0,`"displayName`":`"default`",`"isLocked`":false,`"name`":`"$layerId`",`"opacity`":100.0,`"resourceType`":`"GMImageLayer`",`"resourceVersion`":`"2.0`",`"visible`":true,},
  ],
  `"name`":`"$Name`",
  `"nineSlice`":null,
  `"origin`":$Origin,
  `"parent`":{`"name`":`"Jogo_guloso`",`"path`":`"Jogo_guloso.yyp`",},
  `"preMultiplyAlpha`":false,
  `"resourceType`":`"GMSprite`",
  `"resourceVersion`":`"2.0`",
  `"sequence`":{
    `"`$GMSequence`":`"v1`",
    `"%Name`":`"$Name`",
    `"autoRecord`":true,
    `"backdropHeight`":768,
    `"backdropImageOpacity`":0.5,
    `"backdropImagePath`":`"`",
    `"backdropWidth`":1366,
    `"backdropXOffset`":0.0,
    `"backdropYOffset`":0.0,
    `"events`":{`"`$KeyframeStore<MessageEventKeyframe>`":`"`",`"Keyframes`":[],`"resourceType`":`"KeyframeStore<MessageEventKeyframe>`",`"resourceVersion`":`"2.0`",},
    `"eventStubScript`":null,
    `"eventToFunction`":{},
    `"length`":$($Files.Count).0,
    `"lockOrigin`":false,
    `"moments`":{`"`$KeyframeStore<MomentsEventKeyframe>`":`"`",`"Keyframes`":[],`"resourceType`":`"KeyframeStore<MomentsEventKeyframe>`",`"resourceVersion`":`"2.0`",},
    `"name`":`"$Name`",
    `"playback`":1,
    `"playbackSpeed`":$Fps,
    `"playbackSpeedType`":0,
    `"resourceType`":`"GMSequence`",
    `"resourceVersion`":`"2.0`",
    `"showBackdrop`":true,
    `"showBackdropImage`":false,
    `"timeUnits`":1,
    `"tracks`":[
      {`"`$GMSpriteFramesTrack`":`"`",`"builtinName`":0,`"events`":[],`"inheritsTrackColour`":true,`"interpolation`":1,`"isCreationTrack`":false,`"keyframes`":{`"`$KeyframeStore<SpriteFrameKeyframe>`":`"`",`"Keyframes`":[
$($keys -join "`n")
          ],`"resourceType`":`"KeyframeStore<SpriteFrameKeyframe>`",`"resourceVersion`":`"2.0`",},`"modifiers`":[],`"name`":`"frames`",`"resourceType`":`"GMSpriteFramesTrack`",`"resourceVersion`":`"2.0`",`"spriteId`":null,`"trackColour`":0,`"tracks`":[],`"traits`":0,},
    ],
    `"visibleRange`":null,
    `"volume`":1.0,
    `"xorigin`":$XOrigin,
    `"yorigin`":$YOrigin,
  },
  `"swatchColours`":null,
  `"swfPrecision`":0.5,
  `"textureGroupId`":{`"name`":`"Default`",`"path`":`"texturegroups/Default`",},
  `"type`":0,
  `"VTile`":false,
  `"width`":$Width,
}
"@

    Set-Content -LiteralPath (Join-Path $spriteDir "$Name.yy") -Value $yy -Encoding utf8NoBOM
}

function New-GmSound {
    param([string]$Name, [string]$SourceFile, [double]$Duration, [double]$Volume = 1.0)
    $soundDir = Join-Path $projectRoot "sounds\$Name"
    New-Item -ItemType Directory -Path $soundDir -Force | Out-Null
    Copy-Item -LiteralPath (Join-Path $SourceDir $SourceFile) -Destination (Join-Path $soundDir "$Name.mp3") -Force
    $yy = @"
{
  `"`$GMSound`":`"v2`",
  `"%Name`":`"$Name`",
  `"audioGroupId`":{`"name`":`"audiogroup_default`",`"path`":`"audiogroups/audiogroup_default`",},
  `"bitDepth`":1,
  `"channelFormat`":0,
  `"compression`":0,
  `"compressionQuality`":4,
  `"conversionMode`":0,
  `"duration`":$Duration,
  `"exportDir`":`"`",
  `"name`":`"$Name`",
  `"parent`":{`"name`":`"Jogo_guloso`",`"path`":`"Jogo_guloso.yyp`",},
  `"preload`":false,
  `"resourceType`":`"GMSound`",
  `"resourceVersion`":`"2.0`",
  `"sampleRate`":44100,
  `"soundFile`":`"$Name.mp3`",
  `"volume`":$Volume,
}
"@
    Set-Content -LiteralPath (Join-Path $soundDir "$Name.yy") -Value $yy -Encoding utf8NoBOM
}

New-GmSprite -Name "spr_fase2_background" -Files @("Fábrica1.jpg.jpeg") -Width 1920 -Height 1080 -Fps 1 -Origin 0 -XOrigin 0 -YOrigin 0 -BboxRight 1919 -BboxBottom 1079
New-GmSprite -Name "spr_fase2_boss_background" -Files @("Fábrica2.jpg.jpeg") -Width 1920 -Height 1080 -Fps 1 -Origin 0 -XOrigin 0 -YOrigin 0 -BboxRight 1919 -BboxBottom 1079
New-GmSprite -Name "spr_cagliostro_talk" -Files @("CagliostroFala1.png", "CagliostroFala2.png") -Width 96 -Height 96 -Fps 7 -BboxLeft 8 -BboxTop 3 -BboxRight 87 -BboxBottom 95
New-GmSprite -Name "spr_cagliostro_no_hat" -Files @("Cagliostro_semCartola.png") -Width 96 -Height 96 -Fps 1 -BboxLeft 8 -BboxTop 3 -BboxRight 87 -BboxBottom 95
New-GmSprite -Name "spr_cagliostro_cigar_draw" -Files @("Cagliostro_Charuto1.png", "Cagliostro_Charuto2.png", "Cagliostro_Charuto3.png", "Cagliostro_Charuto4.png") -Width 96 -Height 96 -Fps 6 -BboxLeft 8 -BboxTop 3 -BboxRight 87 -BboxBottom 95
New-GmSprite -Name "spr_cagliostro_idle" -Files @("Cagliostro_Charuto_Idle1.png", "Cagliostro_Charuto_Idle2.png") -Width 96 -Height 96 -Fps 4 -BboxLeft 8 -BboxTop 3 -BboxRight 87 -BboxBottom 95
New-GmSprite -Name "spr_cagliostro_smoke" -Files @("Smoke1.png", "Smoke2.png") -Width 64 -Height 64 -Fps 8 -XOrigin 32 -YOrigin 32 -BboxLeft 8 -BboxTop 5 -BboxRight 56 -BboxBottom 58
New-GmSprite -Name "spr_cagliostro_hat" -Files @("Chapeu1.png", "Chapeu2.png") -Width 96 -Height 96 -Fps 10 -XOrigin 48 -YOrigin 48 -BboxLeft 19 -BboxTop 28 -BboxRight 76 -BboxBottom 57

New-GmSound -Name "snd_cagliostro_fala" -SourceFile "WhatsApp Audio 2026-11-19 at 16.13.35.mpeg" -Duration 47.0
New-GmSound -Name "snd_cagliostro_tema" -SourceFile "WhatsApp Audio 2026-11-19 at 16.13.37.mpeg" -Duration 412.0

# Efeito curto de fósforo: ruído filtrado, ataque rápido e estalo final.
$matchDir = Join-Path $projectRoot "sounds\snd_cagliostro_fosforo"
New-Item -ItemType Directory -Path $matchDir -Force | Out-Null
$wavPath = Join-Path $matchDir "snd_cagliostro_fosforo.wav"
$sampleRate = 44100
$seconds = 0.72
$count = [int]($sampleRate * $seconds)
$pcm = New-Object byte[] ($count * 2)
$rng = [Random]::new(1977)
$last = 0.0
for ($i = 0; $i -lt $count; $i++) {
    $t = $i / $sampleRate
    $env = if ($t -lt 0.035) { $t / 0.035 } else { [Math]::Exp(-5.2 * ($t - 0.035)) }
    $noise = ($rng.NextDouble() * 2.0 - 1.0)
    $last = $last * 0.58 + $noise * 0.42
    $crackle = if (($i % 1171) -lt 12) { [Math]::Sin($i * 0.9) * 0.7 } else { 0.0 }
    $sample = [int16]([Math]::Max(-1.0, [Math]::Min(1.0, ($last * 0.58 + $crackle) * $env)) * 32767)
    $pcm[$i * 2] = $sample -band 0xff
    $pcm[$i * 2 + 1] = ($sample -shr 8) -band 0xff
}
$stream = [IO.File]::Open($wavPath, [IO.FileMode]::Create)
$writer = [IO.BinaryWriter]::new($stream)
$writer.Write([Text.Encoding]::ASCII.GetBytes("RIFF")); $writer.Write([int](36 + $pcm.Length)); $writer.Write([Text.Encoding]::ASCII.GetBytes("WAVE"))
$writer.Write([Text.Encoding]::ASCII.GetBytes("fmt ")); $writer.Write([int]16); $writer.Write([int16]1); $writer.Write([int16]1); $writer.Write([int]$sampleRate); $writer.Write([int]($sampleRate * 2)); $writer.Write([int16]2); $writer.Write([int16]16)
$writer.Write([Text.Encoding]::ASCII.GetBytes("data")); $writer.Write([int]$pcm.Length); $writer.Write($pcm)
$writer.Dispose(); $stream.Dispose()

$matchYy = @"
{
  `"`$GMSound`":`"v2`",`"%Name`":`"snd_cagliostro_fosforo`",`"audioGroupId`":{`"name`":`"audiogroup_default`",`"path`":`"audiogroups/audiogroup_default`",},`"bitDepth`":1,`"channelFormat`":0,`"compression`":0,`"compressionQuality`":4,`"conversionMode`":0,`"duration`":0.72,`"exportDir`":`"`",`"name`":`"snd_cagliostro_fosforo`",`"parent`":{`"name`":`"Jogo_guloso`",`"path`":`"Jogo_guloso.yyp`",},`"preload`":false,`"resourceType`":`"GMSound`",`"resourceVersion`":`"2.0`",`"sampleRate`":44100,`"soundFile`":`"snd_cagliostro_fosforo.wav`",`"volume`":1.0,
}
"@
Set-Content -LiteralPath (Join-Path $matchDir "snd_cagliostro_fosforo.yy") -Value $matchYy -Encoding utf8NoBOM

Write-Host "Recursos da Fase 2 importados com sucesso."
