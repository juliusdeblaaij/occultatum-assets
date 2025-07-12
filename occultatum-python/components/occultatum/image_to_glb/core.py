import torch
from huggingface_hub import hf_hub_download
from PIL import Image

# Barebones TSR class
class TSR:
    def __init__(self, model):
        self.model = model

    @classmethod
    def from_pretrained(cls, model_path, weight_name=None, model_class=None):
        model_file = hf_hub_download(repo_id=model_path, filename="model.ckpt")
        model = torch.load(model_file, map_location="cpu")
        return cls(model)
    
    @classmethod
    def forward(
        self,
        image: Image,
    ) -> torch.FloatTensor:
        rgb_cond = self.image_processor(image, 512)[:, None].to(
            "cpu"
        )
        batch_size = rgb_cond.shape[0]

        input_image_tokens: torch.Tensor = self.image_tokenizer(
            rearrange(rgb_cond, "B Nv H W C -> B Nv C H W", Nv=1),
        )

        input_image_tokens = rearrange(
            input_image_tokens, "B Nv C Nt -> B (Nv Nt) C", Nv=1
        )

        tokens: torch.Tensor = self.tokenizer(batch_size)

        tokens = self.backbone(
            tokens,
            encoder_hidden_states=input_image_tokens,
        )

        scene_codes = self.post_processor(self.tokenizer.detokenize(tokens))
        return scene_codes

# Singleton model instance
_model = None

def get_triposr_model(
    model_path="stabilityai/TripoSR",
):
    """
    Loads and returns the TripoSR model singleton.
    """
    global _model
    if _model is not None:
        return _model

    # Use the local barebones TSR class
    model = TSR.from_pretrained(
        model_path,
    )
    _model = model
    return _model