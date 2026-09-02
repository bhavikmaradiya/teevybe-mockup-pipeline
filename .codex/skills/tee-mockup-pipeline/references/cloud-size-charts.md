# Cloud size-chart transport mirror

This reference defines only how an ephemeral web/cloud Scheduled task obtains the already-approved final `07.jpg` JPEG. It does not create, replace, summarize, or alter a size-chart rule. The current `AGENTS.md` remains authoritative, and local/project runs continue to use `assets/size-charts/` directly.

## Configured Drive mirror

The exact approved repository JPEGs are mirrored as ordinary binary files in this private Google Drive folder:

- Folder: `TeeVybe Cloud Templates`
- Folder ID: `10uUj5Zli_2RDVXKNEHP0gp-St3Z5CDKL`
- URL: `https://drive.google.com/drive/folders/10uUj5Zli_2RDVXKNEHP0gp-St3Z5CDKL`

Use only the profile-matched file below:

| Locked profile | Exact filename | Drive file ID | Bytes | SHA-256 |
| --- | --- | --- | ---: | --- |
| `oversized fit` | `Oversized T-Shirt Size Chart.jpg` | `1Om8WMdCL9nKCZgStuIpbXxsTZFbWtsJu` | 327923 | `bb314845205dfd376633533f72a342addeca2241fd10aabdead389e51bc01dca` |
| `regular fit` | `Regular T-Shirt Size Chart.jpg` | `14YfdW-YPd6ZXUH8ken65cSYOHzoUTU1T` | 434240 | `1224f4e865a0f8df464d39ff692525276940e09be516861e6bd8b34acaae1477` |
| `polo fit` | `POLO T-Shirt Size Chart.jpg` | `1K0-MC4rs3-X3BjXyqQy43Zxsdu5EvgLv` | 424075 | `ba1bab47d6f6abaf61677cc888484e29e1c9400d0c65a451e904002589891243` |

Every listed source is an `image/jpeg` file with exact dimensions `1080 x 1440`.

## Mandatory cloud retrieval and validation

1. Ground the configured folder and selected file through Google Drive metadata. Match its exact filename, parent folder, file ID, MIME type, and byte size to the table above.
2. Fetch the selected stored JPEG through Google Drive as a complete raw binary download or streamed file reference. Prefer the connector's raw-file mode with inline base64 disabled. Do not request, reconstruct, or accept a truncated inline-base64 rendering from GitHub or Drive.
3. Materialize the complete raw file in the run's ephemeral workspace. Verify its JPEG format, exact `1080 x 1440` dimensions, exact byte size, and SHA-256 against the table above before generation begins.
4. Record the selected Drive file ID, observed metadata, and verified SHA-256 in batch state. A filename or visual preview alone is not proof.
5. At the `07.jpg` stage, byte-copy that verified local file unchanged to `Men/07.jpg` and `Women/07.jpg`. Do not crop, resize, regenerate, re-encode, add a logo, or make any design-specific change.
6. Verify that the downloaded source and both delivered copies have the same canonical SHA-256.

The Drive files are transport mirrors, not alternate templates. If the connector cannot expose a complete raw file that can be materialized and hashed, or if any metadata/hash/dimension check fails, stop before image generation and report the exact cloud capability failure. Never fall back to a preview, shortened base64, recreated chart, or reduced audit.

