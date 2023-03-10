/* ******************************************************************************
 * index.ts                                                                     *
 * *************************************************************************/ /**
 *
 * @fileoverview Application Entry Point
 *
 * Created on       February 2, 2023
 * @author          Michael Jay Lippert
 *
 * @copyright (c) 2023 Michael Jay Lippert,
 *            MIT License (see https://opensource.org/licenses/MIT)
 *
 * ******************************************************************************/

import config from 'config';

import { logger } from './utils/logger.js';

logger.info(config.get('hello'));
