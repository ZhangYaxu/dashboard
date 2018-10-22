<?php
/**
 * Nextcloud - Dashboard app
 *
 * This file is licensed under the Affero General Public License version 3 or
 * later. See the COPYING file.
 *
 * @author Maxence Lange <maxence@artificial-owl.com>
 * @copyright 2018, Maxence Lange <maxence@artificial-owl.com>
 * @license GNU AGPL version 3 or any later version
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */


namespace OCA\Dashboard\Service\Widgets\Fortunes;

use OCA\Dashboard\Service\ConfigService;
use OCA\Dashboard\Service\MiscService;

class FortunesService {

	const FORTUNES_FILE = __DIR__ . '/../../../../fortunes';


	/** @var ConfigService */
	private $configService;

	/** @var MiscService */
	private $miscService;


	/**
	 * ProviderService constructor.
	 *
	 * @param ConfigService $configService
	 * @param MiscService $miscService
	 *
	 */
	public function __construct(ConfigService $configService, MiscService $miscService) {
		$this->configService = $configService;
		$this->miscService = $miscService;
	}


	public function getRandomFortune() {
		$fortunes = $this->getFortunes();

		return trim($fortunes[array_rand($fortunes)]);
	}


	/**
	 * @return array
	 */
	public function getFortunes() {
		$content = file_get_contents(self::FORTUNES_FILE);
		$fortunes = explode('%', $content);

		return $fortunes;
	}

}