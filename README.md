# tower-defense

![Alt text](<CleanShot 2023-06-18 at 20.37.46.png>)


## Assets

All used assets are freely available. The full list of assets used in this project is:

- https://assetstore.unity.com/packages/2d/environments/isometric-tower-defense-pack-183472
- https://dinvstudio.itch.io/dynamic-space-background-lite-free
- https://vespere-clivus.itch.io/coins-with-pattern
- https://kenney.nl/assets/ui-pack-rpg-expansion
- https://kenney.nl/assets/ui-pack
- https://kenney.nl/assets/rpg-audio
- https://kenney.nl/assets/sci-fi-sounds
- https://kenney.nl/assets/impact-sounds
- https://kenney.nl/assets/ui-audio
- https://nimblebeastscollective.itch.io/nb-pixel-font-bundle-2
- https://freepd.com/music/Black%20Knight.mp3

## Releasing

The pipeline can create github releases if it detects a new tag.

### Pre-Release

Create a tag with the prefix `rc-`.
Usually from a release branch or from `dev`!

```bash
git checkout dev
git tag rc-1
git push origin rc-1
```
### Release

Create a tag with the prefix `v`.
Usually from `main`

```bash
git checkout main
git tag v1.0.0
git push origin v1.0.0
```
