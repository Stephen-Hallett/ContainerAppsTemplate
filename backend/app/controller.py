import logging

from .schemas import Test
from .util import log

logger = logging.getLogger(__name__)


class Controller:
    def __init__(self) -> None:
        self.logger = logging.getLogger(__name__)

    @log
    def test(self) -> Test:
        return {"test": "Dw it's working"}
