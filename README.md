# tower-travel

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